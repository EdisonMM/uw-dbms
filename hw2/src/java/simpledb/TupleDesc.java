package simpledb;

import java.io.Serializable;
import java.util.*;

/**
 * TupleDesc describes the schema of a tuple.
 */
public class TupleDesc implements Serializable {

    /**
     * A help class to facilitate organizing the information of each field
     * */
    public static class TDItem implements Serializable {

        private static final long serialVersionUID = 1L;

        /**
         * The type of the field
         * */
        public final Type fieldType;
        
        /**
         * The name of the field
         * */
        public final String fieldName;

        public TDItem(Type t, String n) {
            this.fieldName = n;
            this.fieldType = t;
        }

        public String toString() {
            return fieldName + "(" + fieldType + ")";
        }
    }

    /**
     * @return
     *        An iterator which iterates over all the field TDItems
     *        that are included in this TupleDesc
     * */
	
	private class TDItemIterator implements Iterator<TDItem>{
		
		private TDItem[] tdItemAr;
		private int currIdx;
		public int length;
		public TDItemIterator(Type[] typeAr, String[] fieldAr){
			length = typeAr.length;
			tdItemAr = new TDItem[length];
			for(int i = 0; i < length; i++){
				tdItemAr[i] = new TDItem(typeAr[i], fieldAr[i]);
			}
			currIdx = 0;
		}
		public TDItemIterator(Type[] typeAr){
			length = typeAr.length;
			tdItemAr = new TDItem[length];
			for(int i = 0; i < length; i++){
				tdItemAr[i] = new TDItem(typeAr[i], null);
			}
			currIdx = 0;
		}
		public boolean hasNext(){
			return (currIdx < length);
		}
		public TDItem next(){
			TDItem item = tdItemAr[currIdx];
			currIdx++;
			return item;
		}
		public void remove(){
		}
		public void reset(){
			currIdx = 0;
		}
    }

 	private TDItemIterator iterator;

	public Iterator<TDItem> iterator() {
        return iterator;
	}
	
    private static final long serialVersionUID = 1L;

    /**
     * Create a new TupleDesc with typeAr.length fields with fields of the
     * specified types, with associated named fields.
     * 
     * @param typeAr
     *            array specifying the number of and types of fields in this
     *            TupleDesc. It must contain at least one entry.
     * @param fieldAr
     *            array specifying the names of the fields. Note that names may
     *            be null.
     */
    public TupleDesc(Type[] typeAr, String[] fieldAr) {
        // some code goes here
		iterator = new TDItemIterator(typeAr, fieldAr);
    }

    /**
     * Constructor. Create a new tuple desc with typeAr.length fields with
     * fields of the specified types, with anonymous (unnamed) fields.
     * 
     * @param typeAr
     *            array specifying the number of and types of fields in this
     *            TupleDesc. It must contain at least one entry.
     */
    public TupleDesc(Type[] typeAr) {
        // some code goes here
		iterator = new TDItemIterator(typeAr);
    }

    /**
     * @return the number of fields in this TupleDesc
     */
    public int numFields() {
        // some code goes here
        return iterator.length;
    }

    /**
     * Gets the (possibly null) field name of the ith field of this TupleDesc.
     * 
     * @param i
     *            index of the field name to return. It must be a valid index.
     * @return the name of the ith field
     * @throws NoSuchElementException
     *             if i is not a valid field reference.
     */
    public String getFieldName(int i) throws NoSuchElementException {
        // some code goes here
		if (i>0){
			for(int j = 0; j < i; j++){
				if (iterator.hasNext()){
					iterator.next();
				}
				else{
					throw new NoSuchElementException("No Field on index "+i);
				}
			}
		}
		String fieldName = iterator.next().fieldName;
		iterator.reset();
        return fieldName;
    }

    /**
     * Gets the type of the ith field of this TupleDesc.
     * 
     * @param i
     *            The index of the field to get the type of. It must be a valid
     *            index.
     * @return the type of the ith field
     * @throws NoSuchElementException
     *             if i is not a valid field reference.
     */
    public Type getFieldType(int i) throws NoSuchElementException {
        // some code goes here
        
		for(int j = 0; j < i; j++){
			if (iterator.hasNext()){
				iterator.next();
			}
			else{
				throw new NoSuchElementException("No Field on index "+i);
			}
		}
	    Type fieldType = iterator.next().fieldType;
		iterator.reset();
        return fieldType;
    }

    /**
     * Find the index of the field with a given name.
     * 
     * @param name
     *            name of the field.
     * @return the index of the field that is first to have the given name.
     * @throws NoSuchElementException
     *             if no field with a matching name is found.
     */
    public int fieldNameToIndex(String name) throws NoSuchElementException {
        // some code goes here
		for(int i=0; i<iterator.length; i++){
			if (iterator.hasNext()){
				TDItem currItem = iterator.next();
				if (currItem.fieldName == null) continue;
				if (currItem.fieldName.equals(name)){
					iterator.reset();
					return i;
				}
			}
			/*
			else
				throw new Exception("Error in fieldNameToIndex");
			*/
		}
		iterator.reset();
        throw new NoSuchElementException("No field name "+name);
    }

    /**
     * @return The size (in bytes) of tuples corresponding to this TupleDesc.
     *         Note that tuples from a given TupleDesc are of a fixed size.
     */
    public int getSize() {
		int size = 0;
        for(int i=0; i<iterator.length; i++){
			if (iterator.hasNext()){
				Type type = iterator.next().fieldType;
				size += type.getLen();
			}
			/*else{
				throw new Exception("Error in getSize");
			}*/
		}
		iterator.reset();
        return size;
    }

    /**
     * Merge two TupleDescs into one, with td1.numFields + td2.numFields fields,
     * with the first td1.numFields coming from td1 and the remaining from td2.
     * 
     * @param td1
     *            The TupleDesc with the first fields of the new TupleDesc
     * @param td2
     *            The TupleDesc with the last fields of the TupleDesc
     * @return the new TupleDesc
     */
    public static TupleDesc merge(TupleDesc td1, TupleDesc td2) {
        // some code goes here
		TDItemIterator iterator1 = (TDItemIterator) td1.iterator();
		TDItemIterator iterator2 = (TDItemIterator) td2.iterator();
		int length = td1.numFields() + td2.numFields();
		Type[] typeAr = new Type[length];
		String[] fieldAr = new String[length];
	 	boolean td1_turn = true;	
		for(int i = 0; i < length; i++){
			TDItem item;
			if (td1_turn && iterator1.hasNext()){
				item = iterator1.next();
			}
			else if(td1_turn && !(iterator1.hasNext())){
				td1_turn = false;
				iterator1.reset();
				item = iterator2.next();
			}
			else if(!(td1_turn) && iterator2.hasNext()){
				item = iterator2.next();
			}
			else{
				iterator2.reset();
				break;
			}
			typeAr[i] = item.fieldType;
			fieldAr[i] = item.fieldName;
		}
		iterator1.reset();
		iterator2.reset();
        return new TupleDesc(typeAr, fieldAr);
    }

    /**
     * Compares the specified object with this TupleDesc for equality. Two
     * TupleDescs are considered equal if they are the same size and if the n-th
     * type in this TupleDesc is equal to the n-th type in td.
     * 
     * @param o
     *            the Object to be compared for equality with this TupleDesc.
     * @return true if the object is equal to this TupleDesc.
     */
    public boolean equals(Object o) {
        // some code goes here
		
		if (o == null || !this.getClass().equals(o.getClass())){
			return false;
		}
		TupleDesc other = (TupleDesc) o;
		if (this == other) return true;
		if (!(numFields()==other.numFields())){
			return false;
		}
		if (numFields()==0) return true;
		for(int i=0; i<numFields(); i++){
			TDItem item1=null, item2=null;
			if(iterator.hasNext()) item1 = iterator.next();
			if(other.iterator.hasNext()) item2 = other.iterator.next();
			if(!(item1.fieldType == item2.fieldType)){
				iterator.reset();
				other.iterator.reset();
				return false;
			}
		}
		iterator.reset();
		other.iterator.reset();
        return true;
    }

    public int hashCode() {
        // If you want to use TupleDesc as keys for HashMap, implement this so
        // that equal objects have equals hashCode() results
        throw new UnsupportedOperationException("unimplemented");
    }

    /**
     * Returns a String describing this descriptor. It should be of the form
     * "fieldType[0](fieldName[0]), ..., fieldType[M](fieldName[M])", although
     * the exact format does not matter.
     * 
     * @return String describing this descriptor.
     */
    public String toString() {
        // some code goes here
		String str = "";
		for(int i=0; i<numFields(); i++){
			str += iterator.next().toString();
			if (iterator.hasNext()){
				str += ", ";
			}
		}
		iterator.reset();
        return str;
    }
}
