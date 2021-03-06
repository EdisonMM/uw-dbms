package simpledb;

import java.nio.*;
import java.io.*;
import java.util.*;
import java.nio.channels.*;
/**
 * HeapFile is an implementation of a DbFile that stores a collection of tuples
 * in no particular order. Tuples are stored on pages, each of which is a fixed
 * size, and the file is simply a collection of those pages. HeapFile works
 * closely with HeapPage. The format of HeapPages is described in the HeapPage
 * constructor.
 * 
 * @see simpledb.HeapPage#HeapPage
 * @author Sam Madden
 */
public class HeapFile implements DbFile {
    private File f;
    private TupleDesc td;

    //private byte[] buffer;
    //private int pageNum;
    //private int tupPerPage;
    //private int pageByte;

    private TransactionId tid;
    private int fileId;

    private static int nextFileId = 0;

    /**
     * Constructs a heap file backed by the specified file.
     * 
     * @param f
     *            the file that stores the on-disk backing store for this heap
     *            file.
     */
    public HeapFile(File f, TupleDesc td){
        // some code goes here
	fileId = nextFileId;
	nextFileId ++;
	
	this.f = f;
	this.td = td;
    }

    /**
     * Returns the File backing this HeapFile on disk.
     * 
     * @return the File backing this HeapFile on disk.
     */
    public File getFile() {
        // some code goes here
        return f;
    }

    /**
     * Returns an ID uniquely identifying this HeapFile. Implementation note:
     * you will need to generate this tableid somewhere ensure that each
     * HeapFile has a "unique id," and that you always return the same value for
     * a particular HeapFile. We suggest hashing the absolute file name of the
     * file underlying the heapfile, i.e. f.getAbsoluteFile().hashCode().
     * 
     * @return an ID uniquely identifying this HeapFile.
     */
    public int getId() {
        // some code goes here
    	return fileId;
	//return 31 * f.getAbsoluteFile().hashCode() + 117;
    }

    /**
     * Returns the TupleDesc of the table stored in this DbFile.
     * 
     * @return TupleDesc of this DbFile.
     */
    public TupleDesc getTupleDesc() {
        // some code goes here
    	return td;
    }

    // see DbFile.java for javadocs
    public Page readPage(PageId pid) {
	try {
    		RandomAccessFile f_ = new RandomAccessFile(this.f, "r");
    		int offset = BufferPool.PAGE_SIZE * pid.pageNumber();
    		byte[] data = new byte[BufferPool.PAGE_SIZE];
    		if (offset + BufferPool.PAGE_SIZE > f_.length()) {
    			System.err.println("Page ofset exceeds max size!");
    			System.exit(1);
    		}
    		f_.seek(offset);
    		f_.readFully(data);
    		f_.close();
    		return new HeapPage((HeapPageId) pid, data);
    	} catch (FileNotFoundException e) {
    		System.err.println("FileNotFoundException: " + e.getMessage());
    		throw new IllegalArgumentException(); 		
    	} catch (IOException e) {
    		System.err.println("Caught IOException: " + e.getMessage());
            throw new IllegalArgumentException();
    	}
    }

    // see DbFile.java for javadocs
    public void writePage(Page page) throws IOException {
        // some code goes here
    	// not necessary for this assignment
    }

    /**
     * Returns the number of pages in this HeapFile.
     */
    public int numPages() {
        // some code goes here
	int numPage = 0;
	try{
	    RandomAccessFile fileOnDisk = new RandomAccessFile(f.getAbsolutePath(), "rw");

	    FileChannel fc = fileOnDisk.getChannel();
	    return (int)fc.size()/BufferPool.PAGE_SIZE;
	    /*
	    while(true){
		int nread;
	 	ByteBuffer data_buf = ByteBuffer.allocate(BufferPool.PAGE_SIZE);
	   	fc.position(BufferPool.PAGE_SIZE * numPage);
	    	do {
	    	    nread = fc.read(data_buf);
	    	} while (nread != -1 && data_buf.hasRemaining());
	        data_buf.clear();
		numPage ++;
	    }*/
	}catch(IOException e){
	    return -1;
	}catch(IllegalArgumentException e){
	    return -1;
	}
    }

    // see DbFile.java for javadocs
    public ArrayList<Page> insertTuple(TransactionId tid, Tuple t)
            throws DbException, IOException, TransactionAbortedException {
        // some code goes here
    	// not necessary for this assignment
        return null;
    }

    // see DbFile.java for javadocs
    public ArrayList<Page> deleteTuple(TransactionId tid, Tuple t) throws DbException,
            TransactionAbortedException {
        // some code goes here
    	// not necessary for this assignment
        return null;
    }

    // see DbFile.java for javadocs
    public DbFileIterator iterator(TransactionId _tid) {
        // some code goes here
	//tid = _tid;
	
        return new HeapFileIterator(getId(), tid, numPages());
    }
}

