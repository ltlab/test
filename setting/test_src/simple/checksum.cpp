/**
 * Copyright (c) 2021, Jay Huh - All Rights Reserved
 * Author: Jaeyeong Huh <jay.jyhuh@gmail.com>
 * Date  : 2021-05-25 13:04:14 KST
 */

#include <inttypes.h>
#include <stdio.h>  //	size_t
#include <unistd.h>

#include <fstream>

uint8_t calculateSum8(const uint8_t* buffer, uint32_t bufferSize) {
  if (!buffer) return 0;

  uint8_t counter = 0;
  uint32_t index = 0;
  uint32_t sum = 0;

  // while (bufferSize--) { counter += buffer[bufferSize]; }
  for (; index < bufferSize; index++) {
    counter += buffer[index];
    sum += buffer[index];
    if (index < 10) {
      printf("%s| %d: 0x%02x counter: 0x%02x sum: 0x%08x\n", __func__, index,
             buffer[index], counter, sum);
    }
  }

  printf("%s| %d: 0x%02x counter: 0x%02x sum: 0x%08x\n", __func__, index,
         buffer[index], counter, sum);
  return counter;
}

uint8_t calculateChecksum8(const uint8_t* buffer, uint32_t bufferSize) {
  if (!buffer) return 0;

  return (uint8_t)0x100 - calculateSum8(buffer, bufferSize);
}

uint16_t calculateChecksum16(const uint16_t* buffer, uint32_t bufferSize) {
  if (!buffer) return 0;

  uint16_t counter = 0;
  uint32_t index = 0;

  bufferSize /= sizeof(uint16_t);

  for (; index < bufferSize; index++) {
    counter = (uint16_t)(counter + buffer[index]);
    if (index < 10) {
      printf("%s| %d: 0x%02x counter: 0x%02x\n", __func__, index, buffer[index],
             counter);
    }
  }
  printf("%s| %d: 0x%02x counter: 0x%02x\n", __func__, index, buffer[index],
         counter);

  counter = (~counter) + 1;
  return counter;
}

uint32_t calculateChecksum32(const uint32_t* buffer, uint32_t bufferSize) {
  if (!buffer) return 0;

  uint32_t counter = 0;
  uint32_t index = 0;

  bufferSize /= sizeof(uint32_t);

  for (; index < bufferSize; index++) {
    counter = (uint32_t)(counter + buffer[index]);
    if (index < 10) {
      printf("%s| %d: 0x%08x counter: 0x%08x\n", __func__, index, buffer[index],
             counter);
    }
  }
  printf("%s| %d: 0x%08x counter: 0x%08x\n", __func__, index, buffer[index],
         counter);

  counter = (~counter) + 1;
  return counter;
}

int main(int argc, char* argv[]) {
  uint8_t checksum = 0;
  uint16_t checksum16 = 0;
  uint32_t checksum32 = 0;

  std::ifstream in_file;
  std::string file_name;

  while (1) {
    switch (getopt(argc, argv, "f:h")) {
      case 'f': {
        printf("file: %s\n", optarg);
        file_name = std::string(optarg);
        continue;
      }
      case 'h':
      case '?':
      default: {
        printf("Usage: %s -f [filename]\n", argv[0]);
        return -1;
      }
      case -1: {
        break;
      }
    }
    break;
  }

  in_file.open(file_name.c_str(), std::ios::in | std::ios::binary);

  if (in_file.is_open()) {
    in_file.seekg(0, in_file.end);
    ssize_t length = in_file.tellg();
    in_file.seekg(0, in_file.beg);

    uint8_t* pBuffer = new uint8_t[length]{0x0};

    in_file.read(reinterpret_cast<char*>(pBuffer), length);
    printf("%s | pBuffer: %s\n", file_name.c_str(), pBuffer);
    checksum = calculateChecksum8(pBuffer, length);
    checksum16 =
        calculateChecksum16(reinterpret_cast<const uint16_t*>(pBuffer), length);
    checksum32 =
        calculateChecksum32(reinterpret_cast<const uint32_t*>(pBuffer), length);

    delete[] pBuffer;
    in_file.close();
  }

  printf("==================================\n");
  printf("checksum: 0x%x 0x%04x 0x%08x\n", checksum, checksum16, checksum32);

  return 0;
}
