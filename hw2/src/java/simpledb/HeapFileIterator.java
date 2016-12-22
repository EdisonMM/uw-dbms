package simpledb;
import java.util.*;
import java.io.*;

public class HeapFileIterator implements DbFileIterator, Serializable{
    private int fileId;
    private TransactionId tid;
    private Permissions perm;
    private int numPage;
    private int currNumPage;
    private Iterator<Tuple> currIter;

    public HeapFileIterator(int fileId, TransactionId tid, int numPage){
	this.fileId = fileId;
	this.tid = tid;
	this.perm = Permissions.READ_WRITE;
	this.numPage = numPage;
    }
    private void setIter() throws TransactionAbortedException, DbException{
        HeapPageId pid = new HeapPageId(fileId, currNumPage);
	currIter = ((HeapPage)Database.getBufferPool().getPage(tid, pid, perm)).iterator();
    }
    public void open() throws DbException, TransactionAbortedException{
	currNumPage = 0;
	setIter();
    }
    public boolean hasNext() throws DbException, TransactionAbortedException{
	if(currNumPage < numPage-1 || currIter.hasNext()) return true;
	return false;
    }
    public Tuple next() throws DbException, NoSuchElementException, TransactionAbortedException{
	if(this.hasNext()){
	    if(currIter.hasNext()) return currIter.next();
	    else{
		currNumPage ++;
		setIter();
		return currIter.next();
	    }
	}
	throw new NoSuchElementException();
    }
    public void rewind() throws DbException, TransactionAbortedException{
	open();
    }
    public void close(){
	currIter = null;
    }




}





