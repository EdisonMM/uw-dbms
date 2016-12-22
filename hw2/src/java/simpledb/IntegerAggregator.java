
package simpledb;

import java.util.*;

/**
 * Knows how to compute some aggregate over a set of IntFields.
 */
public class IntegerAggregator implements Aggregator {

    private static final long serialVersionUID = 1L;

    /**
     * Aggregate constructor
     * 
     * @param gbfield
     *            the 0-based index of the group-by field in the tuple, or
     *            NO_GROUPING if there is no grouping
     * @param gbfieldtype
     *            the type of the group by field (e.g., Type.INT_TYPE), or null
     *            if there is no grouping
     * @param afield
     *            the 0-based index of the aggregate field in the tuple
     * @param what
     *            the aggregation operator
     */

    private int gfield;
    private Type gfieldType;
    private int afield;
    private Op what;
    private ArrayList<Field> gArr;
    private ArrayList<IntField> aArr;
    private ArrayList<IntField> cArr;

    public IntegerAggregator(int gfield, Type gfieldtype, int afield, Op what) {
        // some code goes here
	this.gfield = gfield;
	this.gfieldType = gfieldtype;
	this.afield = afield;
	this.what = what;
	this.gArr = new ArrayList<Field>();
	this.aArr = new ArrayList<IntField>();
	this.cArr = new ArrayList<IntField>();
    }

    /**
     * Merge a new tuple into the aggregate, grouping as indicated in the
     * constructor
     * 
     * @param tup
     *            the Tuple containing an aggregate field and a group-by field
     */
    public void mergeTupleIntoGroup(Tuple tup) {
        // some code goes here
	IntField af = (IntField)tup.getField(afield);
	boolean newGroup = false;
	int index = 0;
	if(gfield==-1){
	    if(aArr.size()==0) newGroup = true;
	}
	else{
	    Field gf = tup.getField(gfield);
	    if(gArr.indexOf(gf)==-1){
	    	gArr.add(gf);
	    	newGroup = true;
	    }
	    index = gArr.indexOf(gf);
	}
	
	if(what == Op.MIN){
	    if(newGroup) aArr.add(af);
	    else aArr.set(index, new IntField(Math.min(af.getValue(), aArr.get(index).getValue())));
	}else if(what == Op.MAX){
	    if(newGroup) aArr.add(af);
	    else aArr.set(index, new IntField(Math.max(af.getValue(), aArr.get(index).getValue())));
	}else{
	    if(what==Op.AVG || what==Op.SUM){
	    	if(newGroup) aArr.add(af);
		else aArr.set(index, new IntField(af.getValue()+aArr.get(index).getValue()));
	    }
	    if(what==Op.AVG || what==Op.COUNT){
		if(newGroup) cArr.add(new IntField(1));
		else cArr.set(index, new IntField(1+cArr.get(index).getValue()));
	    }
	}
    }

    /**
     * Create a DbIterator over group aggregate results.
     * 
     * @return a DbIterator whose tuples are the pair (groupVal, aggregateVal)
     *         if using group, or a single (aggregateVal) if no grouping. The
     *         aggregateVal is determined by the type of aggregate specified in
     *         the constructor.
     */
    public DbIterator iterator() {
        // some code goes here
	return new DbIterator(){
	    private int curr = 0;
	    private TupleDesc td;
	    public void open(){
		curr = 0;
	    	int n = (gfield==-1)? 1 : 2;
		Type[] typeAr = new Type[n];
		typeAr[n-1] = Type.INT_TYPE;
		if(gfield==-1){
	    	    typeAr[0] = gfieldType;
		}
		td = new TupleDesc(typeAr);
	    }	
	    public boolean hasNext(){
		int size = (what==Op.COUNT)? cArr.size() : aArr.size();
		return (curr<size);
	    }
	    public Tuple next(){
		if(!hasNext()) return null;

		Tuple t = new Tuple(td);
		int n = (gfieldType==null)? 1:2;
		int fieldValue;
		if(what==Op.AVG) fieldValue = aArr.get(curr).getValue()/cArr.get(curr).getValue();
		else if(what==Op.COUNT) fieldValue = cArr.get(curr).getValue();
		else fieldValue = aArr.get(curr).getValue();
		t.setField(n-1, new IntField(fieldValue));
		if(gfieldType!=null){
		    t.setField(0, gArr.get(curr));
		}
		curr++;
		return t;
	    }
	    public void rewind(){
		curr=0;
	    }
	    public TupleDesc getTupleDesc(){
		return td;
	    }
	    public void close(){}


	};
    }

}
