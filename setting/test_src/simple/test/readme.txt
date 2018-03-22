W?tki
-----

1. Co to s? w?tki?
   ---------------

   W?tki s? cz?sto nazywane lekkimi procesami, poniewa? s? podobne do proces?w uniksowych.

   Aby wyja?ni? r??nic? mi?dzy procesem i w?tkiem nale?y zdefiniowa? poj?cie procesu.
   Proces zawiera wykonywalny program (kod programu), grup? zasob?w takich jak 
   deskryptory plik?w, zarezerwowane bloki pami?ci etc. oraz kontekst czyli pozycj?
   wska?nika stosu oraz warto?? licznika rozkaz?w. 

   W?tki mog? wsp??dzieli? zasoby w obr?bie jednego procesu. Mog? korzysta? z tych samych 
   obszar?w pami?ci, pisa? do tych samych plik?w. Jedyne co charakteryzuje w?tek to jego
   kontekst. Na program napisany z u?yciem w?tk?w mo?na spojrze? jak na grup? zasob?w 
   dzielon? przez kilka mini-proces?w.

   W zwi?zku z tym, ?e w?tki s? "ma?e" w por?wnaniu do proces?w, ich obs?uga jest mniej 
   kosztowna dla systemu operacyjnego. Mniej pracoch?onne jest utworzenie nowego w?tku,
   bo nie trzeba przydziela? dla niego zasob?w, mniej czasu zabiera te? zako?czenie
   w?tku, bo system operacyjny nie musi po nim "sprz?ta?". Jednak g??wny zysk polega 
   na zmniejszeniu kosztu prze??czania mi?dzy w?tkami w obr?bie jednego procesu. 

   Prze??czenie kontekstu, kt?re normalnie odbywa si? wiele razy na sekund? w j?drze 
   systemu operacyjnego, jest operacj? kosztown?. Wi??e si? ono ze zmian? struktur 
   systemowych, wczytaniem odpowiednich warto?ci do rejestr?w procesora. Dlatego w?a?nie
   wymy?lono mechanizm w?tk?w, aby zredukowa? koszt pojedynczego prze??czenia. 


2. Implementacja w?tk?w
   --------------------

   Ze wzgl?du na spos?b implementacji, wyr??niamy dwa typy w?tk?w: w?tki poziomu 
   u?ytkownika (user-space threads) i w?tki poziomu j?dra (kernel-space threads).

   W?tki poziomu u?ytkownika
   -------------------------

   W?tki poziomu u?ytkownika rezygnuj? z zarz?dzania wykonaniem przez j?dro i robi? 
   to same. Cz?sto jest to nazywane "wielow?tkowo?ci? sp??dzielcz?", gdy? proces 
   definiuje zbi?r wykonywalnych procedur, kt?re s? "wymieniane" przez operacje 
   na wska?niku stosu. Zwykle ka?dy w?tek "rezygnuje" z procesora przez bezpo?rednie 
   wywo?anie ??dania wymiany (wys?anie sygna?u i zainicjowanie mechanizmu zarz?dzaj?cego)
   albo przez odebranie sygna?u zegara systemowego. 

   Implementacje w?tk?w poziomu u?ytkownika napotykaj? na liczne problemy, kt?re trudno 
   obej??, np.:

      - problem "kradzenia" czasu wykonania innych w?tk?w przez jeden w?tek, 
      - brak sposobu wykorzystania mo?liwo?ci SMP (ang. symmetric multiprocessing, 
        czyli obs?uga wielu procesor?w), 
      - oczekiwanie jednego z w?tk?w na zako?czenie blokuj?cej operacji wej?cia/wyj?cia 
        powoduje, ?e inne w?tki tego procesu te? trac? sw?j czas wykonania. 

   Obecnie w?tki poziomu u?ytkownika mog? szybciej dokona? wymiany ni? w?tki poziomu j?dra,
   ale ci?g?y rozw?j tych drugich powoduje, ?e ta r??nica jest bardzo ma?a.

   W?tki poziomu j?dra
   -------------------

   W?tki poziomu j?dra s? cz?sto implementowane poprzez do??czenie do ka?dego procesu 
   tabeli/listy jego w?tk?w. W tym rozwi?zaniu system zarz?dza ka?dym w?tkiem wykorzystuj?c 
   kwant czasu przyznany dla jego procesu-rodzica.

   Zalet? takiej implementacji jest znikni?cie zjawiska "kradzenia" czasu wykonania innych 
   w?tk?w przez "zach?anny" w?tek, bo zegar systemowy tyka niezale?nie i system wydziedzicza
   "niesforny" w?tek. Tak?e blokowanie operacji wej?cia/wyj?cia nie jest ju? problemem.
   Ponadto przy poprawnym zakodowaniu programu, proces mo?e automatycznie wyci?gn?? korzy?ci 
   z istnienia SMP przy?pieszaj?c swoje wykonanie przy ka?dym dodatkowym procesorze.


3. R??ne implementacje w?tk?w
   --------------------------

   Na zaj?ciach om?wimy w?tki zgodne ze standardem POSIX, czyli tak zwane "pthreads"
   (POSIX Threads). Standard ten w Linuksie jest zaimplementowany w bibliotekach
   LinuxThreads i NPTL (Native POSIX Threads Library). Obie implementuj? w?tki na poziomie
   j?dra. Aby sprawdzi?, jak? implementacj? dostarcza nasz system, mo?na wywo?a?

     getconf GNU_LIBPTHREAD_VERSION

   Programy u?ywaj?ce w?tk?w nale?y kompilowa? z opcj? -pthread.

 * man pthreads

4. Jak utworzy? w?tek?
   -------------------

   Do tworzenia w?tk?w s?u?y funkcja pthread_create.

   int pthread_create(pthread_t *thread, pthhread_attr_t *attr,
                      void * (* func)(void *), void *arg);
 * man pthread_create

   Funkcja ta tworzy w?tek, kt?rego kod wykonywalny znajduje si? w funkcji podanej jako
   argument func. W?tek jest uruchamiany z parametrem arg, a informacja o w?tku 
   (deskryptor w?tku) jest umieszczana w strukturze thread.

   Podczas wywo?ania funkcji pthread_create tworzony jest w?tek, kt?ry dzia?a do chwili
   gdy funkcja b?d?ca tre?ci? w?tku zostanie zako?czona przez return, wywo?anie funkcji
   pthread_exit lub po prostu zostanie wykonana ostatnia instrukcja funkcji.

   Argument attr zawiera atrybuty z jakimi chcemy stworzy? w?tek. Do obs?ugi atrybut?w
   w?tku s?u?? funkcje pthread_attr_*. S? to mi?dzy innymi:

   int pthread_attr_init(pthread_attr_t *attr);
   int ptrehad_attr_destroy(pthread_attr_t *attr);
           Inicjowanie obiektu attr domy?lnymi warto?ciami oraz niszczenie obiektu attr.

   int pthread_attr_setdetachstate(pthread_attr_t *attr, int state);
           Ustawianie atrybutu "detachstate". Mo?liwe warto?ci to PTHREAD_CREATE_JOINABLE
	   (domy?lna) i PTHREAD_CREATE_DETACHED. Atrybut ten okre?la, czy mo?na czeka?
	   na zako?czenie w?tku.

 * man pthread_attr_setdetachstate

5. Jak czeka? na zako?czenie w?tku?
   --------------------------------

   Podobnie jak w przypadku proces?w program g??wny mo?e oczekiwa? na zako?czenie si? 
   w?tk?w, kt?re stworzy? - s?u?y do tego funkcja pthread_join.

   int pthread_join(pthread_t thread, void **status);

 * man pthread_join
   
   Co najwy?ej jeden w?tek mo?e czeka? na zako?czenie jakiego? w?tku. Wywo?anie join dla
   w?tku, na kt?ry kto? ju? czeka, zako?czy si? b??dem.
   
6. Na jakie w?tki mo?na czeka??
   ----------------------------

   Tak jak powiedzieli?my, czeka? mo?na na w?tki, kt?re zosta?y stworzone z atrybutem
   detachstate ustawionym na PTHREAD_CREATE_JOINABLE.

   Po uruchomieniu w?tku mo?na jeszcze zmieni? warto?? tego atrybutu poprzez wywo?anie
   funkcji pthread_detach, kt?ra powoduje, ?e na w?tek nie mo?na b?dzie oczekiwa?. Taki 
   w?tek b?dziemy nazywa? "od??czonym". 

   int pthread_detach(pthread_t thread);

 * man pthread_detach

   Je?li w?tek przejdzie w stan od??czony to zaraz po zako?czeniu tego w?tku czyszczone
   s? wszystkie zwi?zane z nim struktury w pami?ci. Je?li jednak w?tek nie przejdzie 
   do stanu od??czony to informacja o jego zako?czeniu pozostanie w pami?ci do czasu, 
   a? inny w?tek wykona funkcj? pthread_join dla zako?czonego w?tku.

 * Przeanalizuj program threads.c. Spr?buj wywo?a? go z parametrem i bez parametru, 
   zaobserwuj co stanie si? je?li w?tki zostan? utworzone jako od??czone.

7. Synchronizacja w?tk?w
   ---------------------

   Do synchronizacji w?tk?w niezbyt dobrze nadaj? si? dotychczas poznane mechanizmy, 
   dlatego istniej? osobne dla nich mechanizmy synchronizacyjne: muteksy i zmienne
   warunkowe.

   Muteksy
   -------

   Nast?puj?ce funkcje s? dost?pne dla muteks?w:

   int pthread_mutex_init(pthread_mutex_t *mutex, pthread_mutexattr_t *attr);
   int pthread_mutex_destroy(pthread_mutex_t *mutex);
           Inicjowanie muteksa i niszczenie go.

   int pthread_mutex_lock(pthread_mutex_t *mutex);
   int pthread_mutex_trylock(pthread_mutex_t *mutex);
   int pthread_mutex_unlock(pthread_mutex_t *mutex);
           Semaforowe operacje na muteksie, obja?nione poni?ej.

   Muteks mo?e by? w dw?ch stanach: mo?e by? wolny albo mo?e by? w posiadaniu 
   pewnego w?tku. Proces, kt?ry chce zdoby? muteks wykonuje operacj? lock. Je?li muteks 
   jest wolny, to operacja ko?czy si? powodzeniem i w?tek staje si? w?a?cicielem muteksa. 
   Je?li jednak muteks jest w posiadaniu innego w?tku, to operacja powoduje wstrzymanie 
   w?tku a? do momentu kiedy muteks b?dzie wolny. Przypomina to zatem operacje wej?cia
   do monitora.

   Operacja trylock dzia?a podobnie, z wyj?tkiem tego, ?e zwraca b??d w sytuacji, gdy
   w?tek mia?by by? wstrzymany.

   W?tek, kt?ry jest w posiadaniu muteksa mo?e go odda? wykonuj?c operacj? unlock.
   Powoduje to obudzenie pewnego w?tku oczekuj?cego na operacji lock, je?li taki jest i 
   przyznanie mu muteksa. Je?li nikt nie czeka, to muteks staje si? wolny. 
   Przypomina to zatem operacj? wyj?cia z monitora. Zwr??my uwag?, ?e 
   unlock mo?e wykona? tylko ten proces, kt?ry posiada muteks.
   
   Implementacja w Linuksie nie narzuca powy?szego wymogu, ale u?ywanie operacji lock
   i unlock w inny spos?b powoduje nieprzeno?no?? programu. 

 * man pthread_mutex_lock

   Biblioteka LinuxThreads udost?pnia trzy rodzaje muteks?w (rodzaj wybieramy ustawiaj?c
   odpowiedni atrybut podczas tworzenia w?tku), kt?re r??nie reaguj? w sytuacji, gdy
   w?tek wykonuje lock na muteksie, kt?ry ju? posiada. Po szczeg??y odsy?amy do

 * man ptrhead_mutexattr_settype

   Zmienne warunkowe
   -----------------

   Zmienne warunkowe to odpowiednik kolejek w monitorze. Operacje wait() i signal()
   to odpowiednio pthread_cond_wait i pthread_cond_signal.
   
   Aby zasymulowa? dzia?anie monitora nale?y u?ywa? muteksa broni?cego wej?cia do
   monitora. Operacja wej?cia do monitora odpowiada operacji lock na muteksie, 
   a operacja wyj?cia - wykonaniu unlock. Zwr?? uwag?, ?e jest to zgodne z tym,
   ?e unlock mo?e wykona? jedynie proces, kt?ry jest w posiadaniu muteksa (czyli jest
   w monitorze). Operacje na zmiennych warunkowych monitora wykonuje si? za pomoc? 
   pthread_cond_wait oraz pthread_cond_signal. 

   int pthread_cond_init(pthread_cond_t *cond, pthread_condattr_t *cond_attr);
   int pthread_cond_destroy(pthread_cond_t *cond);
           Inicjowanie zmiennej warunkowej (argument cond_attr jest zawsze NULL)
           i niszczenie jej.
   
   int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
           Atomowo zwalnia mutex (kt?ry musia? by? wcze?niej w posiadaniu w?tku) i zawiesza
	   si? na kolejce zmiennej warunkowej cond (chwilowe wyj?cie z monitora).

   int pthread_cond_signal(pthread_cond_t *cond);
           Je?li nikt nie czeka? na kolejce cond, to nic si? nie dzieje. W przeciwnym
	   wypadku jeden z czekaj?cych w?tk?w jest budzony.

 * man pthread_cond_wait

   Standardowy scenariusz u?ycia zmiennej warunkowej wygl?da nast?puj?co:

   pthread_mutex_lock(&mut);
   ...
   while (warunek) 
       pthread_cond_wait(&cond, &mut);
   ...
   pthread_mutex_unlock(&mut);

   Zwr?? uwag? na u?ycie p?tli zamiast warunku! Jest to spowodowane tym, ?e 
   monitory gwarantuj? zwalnianie proces?w oczekuj?cych na zmiennych warunkowych
   przed wpuszczeniem nowych proces?w do monitor?w - dlatego instrukcja if jest
   wystarczaj?ca. W przypadku muteks?w takiej gwarancji nie ma, wi?c po zwolnieniu 
   muteksa do monitora mo?e wej?? inny proces, "zepsu?" warunek, na kt?ry oczekiwa? 
   budzony proces. Obudzony proces musi zatem ponownie sprawdzi?, czy warunek jest 
   spe?niony - st?d u?ycie p?tli.

 * Przeanalizuj program prod_kon.c. Zwr?? uwag? na funkcje put() i get() w kt?rych odbywa
   si? synchronizacja mi?dzy w?tkami producenta i konsumenta.

   Opr?cz powy?szych operacji dost?pne s? r?wnie? dwie dodatkowe:
   pthread_cond_timedwait - czeka tylko przez okre?lony czas,
   pthread_cond_broadcast - budzi wszystkie w?tki czekaj?ce w kolejce.
   
 * Przeanalizuj program timeout.c zwr?? uwag? na u?ycie funkcji pthread_cond_timedwait().

8. Jak wymusi? zako?czenie w?tku?
   ------------------------------

   Aby wymusi? zako?czenie innego w?tku nale?y wywo?a? funkcj? pthread_cancel. W?tek
   mo?e zignorowa? nasze ??danie, zako?czy? si? natychmiast lub od?o?y? zako?czenie na
   bardziej dogodny moment.
   
   int pthread_cancel(pthread_t thread);
           Wymuszenie zako?czenia w?tku thread. Ewentualne zako?czenie w?tku b?dzie
	   r?wnowa?ne wykonaniu pthread_exit(PTHREAD_CANCELED).

   int pthread_setcancelstate(int state, int *oldstate);
           Ustawienie reakcji na ??danie zako?czenia w?tku: PTHREAD_CANCEL_ENABLE (domy?lnie)
           lub PTHREAD_CANCEL_DISABLE (ignorowanie ??da? zako?czenia).

   int pthread_setcanceltype(int type, int *oldtype);
           Ustawienie trybu ko?czenia w?tku: PTHREAD_CANCEL_ASYNCHRONOUS (asynchronicznie),
	   lub PTHREAD_CANCEL_DEFERRED (tryb "deferred", domy?lnie).

 * man pthread_cancel

   Je?li w?tek jest w stanie, w kt?rym nie mo?na go przerwa? to ??danie przerwania go
   funkcj? pthread_cancel jest wstrzymywane do czasu, kiedy b?dzie mo?na zako?czy? 
   w?tek.

9. Dwa tryby ko?czenia w?tk?w
   --------------------------

   Wywo?anie funkcji pthread_cancel powoduje r??n? reakcj? ko?czonego w?tku w zale?no?ci
   od trybu zako?czenia w?tku w jakim znajduje si? ko?czony w?tek.

   W trybie asynchronicznym w?tek jest ko?czony natychmiast w momencie wywo?ania 
   pthread_cancel przez inny w?tek.
   W trybie "deferred" w?tek nie jest ko?czony od razu. Ko?czy si? on dopiero w momencie
   dotarcia do tzw. "cancellation point". Cancellation point jest wi?kszo?? wywo?a?
   funkcji systemowych, nale?y jednak uwa?a? aby wykorzystywa? zgodne z w?tkami 
   biblioteki. 
   Funkcje, kt?re na pewno s? przygotowane do pracy z w?tkami to: read, write, select,
   accept, sendto, recvfrom, connect.
   
   Uwaga: funkcja pthread_mutex_lock nie jest cancellation point.
   
   W?tek mo?e te? sztucznie wej?? do cancellation point wywo?uj?c funkcj? 
   pthread_testcancel.

   void pthread_testcancel(void);

10. Bloki czyszcz?ce
    ----------------

   Aby nie dopu?ci? do blokad wynikaj?cych z przerwania w?tku, kt?ry zablokowa?
   jakie? zasoby (semafory, pliki itp.) wymy?lono mechanizm blok?w czyszcz?cych.
   Po zablokowaniu jakiego? zasobu rejestruje si? funkcj?, kt?ra powinna zosta? 
   wykonana je?li wykonanie w?tku zostanie zak??cone. Robi si? to przy pomocy funkcji 
   pthread_cleanup_push.

   pthread_cleanup_push(void (*func)(void *), void *arg);

 * man pthread_cleanup_push
   
   Aby odrejestrowa? funkcj? czyszcz?c? np. po odblokowaniu zasobu nale?y u?y? 
   funkcji pthread_cleanup_pop.

   pthread_cleanup_pop(int exec);

   Standardowe u?ycie blok?w czyszcz?cych mog?oby wygl?da? nast?puj?co:

   pthread_mutex_lock(&mut);
   pthread_cleanup_push(pthread_mutex_unlock, &mut);
   ...
   pthread_mutex_unlock(&mut);
   pthread_cleanup_pop(FALSE);  

   Dwie ostatnie operacje mo?na po??czy? w jedno wywo?anie funkcji pthread_cleanup_pop
   z argumentem TRUE. Takie wywo?anie oznacza, ?e podczas odrejestrowywania blok 
   zostanie wykonany, zatem w tym przyk?adzie zostanie odblokowany semafor.

   pthread_mutex_lock(&mut);
   pthread_cleanup_push(pthread_mutex_unlock, &mut);
   ...
   //   pthread_mutex_unlock(&mut);
   pthread_cleanup_pop(TRUE);

   Bloki czyszcz?ce s? rejestrowane na stosie, wi?c nie ma przeszk?d aby stosowa? 
   zagnie?d?one bloki czyszcz?ce. W sytuacji za?amania w?tku bloki zostan? wykonane
   w kolejno?ci odwrotnej do ich rejestrowania.

 * Przeanalizuj program cancel.c. Zwr?? uwag? na u?ycie blok?w czyszcz?cych oraz ?wiadome
   wej?cie do cancellation point przy u?yciu pthread_testcancel.


-----
Ostatnia aktualizacja:
18.11.2008, Tomasz Idziaszek
