#include	<stdlib.h>
#include	<stdio.h>
#include	<string.h>


typedef long long int	__int64;

typedef struct BTREE_NODE_S
{
	__int64 key;
	void *pData;

	struct BTREE_NODE_S	*parent;
	struct BTREE_NODE_S	*left;
	struct BTREE_NODE_S	*right;
} BTREE_NODE;

class BinaryTree
{
public:

	BinaryTree();
	~BinaryTree();

	void insert( __int64 key, void *pData );
	bool remove( __int64 key );

	BTREE_NODE* search( __int64 key );
	void destroyTree( void );

	BTREE_NODE* getMinNode( void );
	BTREE_NODE* getMaxNode( void );

	void printInOrder( void );
	void printPostOrder( void );
	void printPreOrder( void );
private:
	BTREE_NODE *m_pRoot;

	void insert( __int64 key, void *pData, BTREE_NODE *pLeaf );
	BTREE_NODE* removeNode( __int64 key, BTREE_NODE *pLeaf );

	void destroyTree( BTREE_NODE *pLeaf );
	BTREE_NODE* search( __int64 key, BTREE_NODE *pLeaf );
	
	BTREE_NODE* getMinNode( BTREE_NODE *pLeaf );
	BTREE_NODE* getMaxNode( BTREE_NODE *pLeaf );

	void printInOrder( BTREE_NODE *pLeaf );
	void printPostOrder( BTREE_NODE *pLeaf );
	void printPreOrder( BTREE_NODE *pLeaf );
protected:
};


