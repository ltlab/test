/*
 * =====================================================================================
 *
 *       Filename:  bin-tree.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2013년 06월 11일 17시 23분 40초
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */



#include	"bin-tree.h"

BinaryTree::BinaryTree()
{
	m_pRoot = NULL;
}

BinaryTree::~BinaryTree()
{
	destroyTree();
}

void BinaryTree::destroyTree( BTREE_NODE *pLeaf )
{
	if( pLeaf == NULL ) { return; }

	destroyTree( pLeaf->left );
	destroyTree( pLeaf->right );

	delete pLeaf;
}

void BinaryTree::insert( __int64 key, void *pData, BTREE_NODE *pLeaf )
{
	if( pLeaf == NULL ) { return ; }

	if( key < pLeaf->key )
	{
		if( pLeaf->left == NULL )
		{
			pLeaf->left = new BTREE_NODE;
			pLeaf->left->key = key;
			pLeaf->left->pData = pData;
			pLeaf->left->parent = pLeaf;
			pLeaf->left->left = NULL;
			pLeaf->left->right = NULL;
			printf("ADD LEFT: pLeaf(%p) parent(%p) key: %lld pData: %p\n", pLeaf->left, pLeaf->left->parent, key, pData );
		}
		else
		{
			insert( key, pData, pLeaf->left );
		}
	}
	else if( key >= pLeaf->key )
	{
		if( pLeaf->right == NULL )
		{
			pLeaf->right = new BTREE_NODE;
			pLeaf->right->key = key;
			pLeaf->right->pData = pData;
			pLeaf->right->parent = pLeaf;
			pLeaf->right->left = NULL;
			pLeaf->right->right = NULL;
			printf("ADD RIGHT: pLeaf(%p) parent(%p) key: %lld pData: %p\n", pLeaf->right, pLeaf->right->parent, key, pData );
		}
		else
		{
			insert( key, pData, pLeaf->right );
		}
	}
	else
	{
		printf("WARNING: key(%lld) was found!!! pData: %p\n", key, pData );
	}
}

bool BinaryTree::remove( __int64 key )
{
	if( m_pRoot == NULL ) { return false; }

	if( key == m_pRoot->key )
	{
		BTREE_NODE tmpRootNode;

		tmpRootNode.key = 0;
		tmpRootNode.pData = NULL;
		tmpRootNode.parent = NULL;
		tmpRootNode.left = NULL;
		tmpRootNode.right = m_pRoot;

		m_pRoot->parent = &tmpRootNode;

		BTREE_NODE *removedNode = removeNode( key, &tmpRootNode );
		if( removedNode == m_pRoot )
		{
			printf( "########## ROOT(%p) will be REMOVED!!! and Change NEW ROOT(%p)!!!\n", m_pRoot, tmpRootNode.right );
		}

		m_pRoot = tmpRootNode.right;
		if( m_pRoot != NULL )
		{
			m_pRoot->parent = NULL;
		}

		if( removedNode != NULL )
		{
			delete removedNode;
			return true;
		}
		else { return false; }

	}
	else
	{
		BTREE_NODE *removedNode = removeNode( key, m_pRoot );

		if( removedNode != NULL )
		{
			delete removedNode;
			return true;
		}
		else { return false; }
	}
}

BTREE_NODE* BinaryTree::removeNode( __int64 key, BTREE_NODE *pLeaf )
{
	if( pLeaf == NULL ) { return NULL; }

	if( key < pLeaf->key )
	{
		return removeNode( key, pLeaf->left );
	}
	else if( key > pLeaf->key )
	{
		return removeNode( key, pLeaf->right );
	}
	else	//	key was found!!
	{
		if( ( pLeaf->left != NULL ) && ( pLeaf->right != NULL ) )
		{
			BTREE_NODE *pTmpNode = NULL; 

			pTmpNode = getMaxNode( pLeaf->left );

			free( pLeaf->pData );

			pLeaf->key = pTmpNode->key;
			pLeaf->pData = pTmpNode->pData;

			return removeNode( pLeaf->key, pLeaf->left );

		}
		else if( pLeaf->parent->left == pLeaf )
		{
			if( pLeaf->left != NULL )
			{
				pLeaf->parent->left = pLeaf->left;
				pLeaf->left->parent = pLeaf->parent;
			}
			else if( pLeaf->right != NULL )
			{
				pLeaf->parent->left = pLeaf->right;
				pLeaf->right->parent = pLeaf->parent;
			}
			else
			{
				pLeaf->parent->left = NULL;
			}

			return pLeaf;
		}
		else if( pLeaf->parent->right == pLeaf )
		{
			if( pLeaf->left != NULL )
			{
				pLeaf->parent->right = pLeaf->left;
				pLeaf->left->parent = pLeaf->parent;
			}
			else if( pLeaf->right != NULL )
			{
				pLeaf->parent->right = pLeaf->right;
				pLeaf->right->parent = pLeaf->parent;
			}
			else
			{
				pLeaf->parent->right = NULL;
			}
			return pLeaf;
		}
	}
}

BTREE_NODE* BinaryTree::search( __int64 key, BTREE_NODE *pLeaf )
{
	if( pLeaf == NULL ) { return NULL; }

	if( key == pLeaf->key ) { return pLeaf; }
	if( key < pLeaf->key )
	{
		return search( key, pLeaf->left );
	}
	else
	{
		return search( key, pLeaf->right );
	}
}

void BinaryTree::printInOrder( BTREE_NODE *pLeaf )
{
	if( pLeaf !=NULL )
	{
		printInOrder( pLeaf->left );
		printf("%s: pLeaf(%p) parent(%p) left(%p) right(%p) key: %lld pData: %p\n", __FUNCTION__, \
				pLeaf, pLeaf->parent, pLeaf->left, pLeaf->right, pLeaf->key, pLeaf->pData );
		printInOrder( pLeaf->right );
	}
}

void BinaryTree::printPostOrder( BTREE_NODE *pLeaf )
{
	if( pLeaf !=NULL )
	{
		printPostOrder( pLeaf->left );
		printPostOrder( pLeaf->right );
		printf("%s: pLeaf(%p) parent(%p) left(%p) right(%p) key: %lld pData: %p\n", __FUNCTION__, \
				pLeaf, pLeaf->parent, pLeaf->left, pLeaf->right, pLeaf->key, pLeaf->pData );
	}
}

void BinaryTree::printPreOrder( BTREE_NODE *pLeaf )
{
	if( pLeaf !=NULL )
	{
		printf("%s: pLeaf(%p) parent(%p) left(%p) right(%p) key: %lld pData: %p\n", __FUNCTION__, \
				pLeaf, pLeaf->parent, pLeaf->left, pLeaf->right, pLeaf->key, pLeaf->pData );
		printPreOrder( pLeaf->left );
		printPreOrder( pLeaf->right );
	}
}

BTREE_NODE* BinaryTree::getMinNode( BTREE_NODE *pLeaf )
{
	if( pLeaf == NULL ) { return NULL; }

	BTREE_NODE *pTmpNode = pLeaf;

	while( pTmpNode != NULL )
	{

		if( pTmpNode->left == NULL )
		{
			printf("MIN: pLeaf(%p) parent(%p) left(%p) right(%p) key: %lld pData: %p\n", \
					pTmpNode, pTmpNode->parent, pTmpNode->left, pTmpNode->right, pTmpNode->key, pTmpNode->pData );
			break;
		}
		else
		{
			pTmpNode = pTmpNode->left;
		}
	}

	return pTmpNode;
}

BTREE_NODE* BinaryTree::getMaxNode( BTREE_NODE *pLeaf )
{
	if( pLeaf == NULL ) { return NULL; }

	BTREE_NODE *pTmpNode = pLeaf;

	while( pTmpNode != NULL )
	{

		if( pTmpNode->right == NULL )
		{
			printf("MAX: pLeaf(%p) parent(%p) left(%p) right(%p) key: %lld pData: %p\n", \
					pTmpNode, pTmpNode->parent, pTmpNode->left, pTmpNode->right, pTmpNode->key, pTmpNode->pData );
			break;
		}
		else
		{
			pTmpNode = pTmpNode->right;
		}
	}

	return pTmpNode;
}

void BinaryTree::insert( __int64 key, void *pData )
{
	if( m_pRoot == NULL )
	{
		m_pRoot = new BTREE_NODE;
		m_pRoot->key = key;
		m_pRoot->pData = pData;
		m_pRoot->parent = NULL;
		m_pRoot->left = NULL;
		m_pRoot->right = NULL;
		printf("m_pRoot(%p) node->left(%p) node->right(%p) key: %lld pData: %p\n", \
				m_pRoot, m_pRoot->left, m_pRoot->right, m_pRoot->key, m_pRoot->pData );
	}
	else
	{
		//printf("INSERT: key: %lld pData: %p\n", key, pData );
		insert( key, pData, m_pRoot );
	}
}

BTREE_NODE* BinaryTree::search( __int64 key )
{
	return search( key, m_pRoot );
}

BTREE_NODE* BinaryTree::getMinNode( void )
{
	return getMinNode( m_pRoot );
}

BTREE_NODE* BinaryTree::getMaxNode( void )
{
	return getMaxNode( m_pRoot );
}

void BinaryTree::destroyTree( void )
{
	destroyTree( m_pRoot );
}

void BinaryTree::printInOrder( void )
{
	printInOrder( m_pRoot );
}

void BinaryTree::printPostOrder( void )
{
	printPostOrder( m_pRoot );
}

void BinaryTree::printPreOrder( void )
{
	printPreOrder( m_pRoot );
}

int main()
{
	BinaryTree	btree;

	BTREE_NODE	*tmp = NULL;

#if 0
	btree.insert( 10, NULL );
	btree.insert( 17, NULL );
	btree.insert( 1, NULL );
	btree.insert( 12, NULL );
	btree.insert( 4, NULL );
	btree.insert( 777, NULL );
	btree.insert( 865, NULL );
	btree.insert( 43, NULL );
	btree.insert( 32, NULL );
	btree.insert( 22, NULL );
	btree.insert( 22, NULL );
	btree.insert( 42, NULL );
#else
	/* Inserting nodes into tree */
	btree.insert( 1, NULL );
	btree.insert(19, NULL );
	btree.insert(19, NULL );
	btree.insert(2, NULL );
	btree.insert(2, NULL );
	btree.insert(19, NULL );
	btree.insert(4, NULL );
	btree.insert(17, NULL );
	btree.insert(15, NULL );
	btree.insert(6, NULL );
	btree.insert(12, NULL );
	btree.insert(17, NULL );
	btree.insert(2, NULL );
	btree.insert(6, NULL );
	btree.insert(2, NULL );
	btree.insert(19, NULL );

#endif
	printf("Pre Order Display\n");
	btree.printPreOrder();

	printf("In Order Display\n");
	btree.printInOrder();

	printf("Post Order Display\n");
	btree.printPostOrder();

	/* Search node into tree */
	tmp = btree.search( 17 );
	if (tmp)
	{
		printf("Searched node=%lld\n", tmp->key);
	}
	else
	{
		printf("Data Not found in tree.\n");
	}

#if 1
	int i = 0;
	while( tmp != NULL )
	{
		//tmp = btree.getMaxNode();
		tmp = btree.getMinNode();
		if (tmp)
		{
			i++;
			printf("\n[%d] Max. node: %p key: %lld\n", i, tmp, tmp->key);
			btree.printInOrder();
			btree.remove( tmp->key );
			printf("[%d] Removed node: %p key: %lld\n", i, tmp, tmp->key);
		}
	}
#endif

	/* Deleting all nodes of tree */
	btree.destroyTree();

	return 0;
}
