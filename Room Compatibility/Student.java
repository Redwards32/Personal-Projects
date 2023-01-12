public class Student{
	String name;
	char gender;
	Date birthDate;
	Preference pref;
	boolean matched;
	
	//Constructor
	public Student(String name, char gender, Date birthDate, Preference pref) {
		this.name = name;
		this.gender = gender;
		this.birthDate = birthDate;
		this.pref = pref;
	}
	//Acessor Methods
	public String getName() {
		return name;
	}
	
	public char getGender() {
		return gender;
	}
	
	public Date getBirthDate() {
		return birthDate;
	}
	
	public Preference getPref() {
		return pref;
	}
	
	public boolean getMatched() {
		return matched;
	}
	
	//Mutator method for matched
	public void setMatched(boolean matched) {
		this.matched = matched;
	}
	
	//Compare method
	public int compare(Student st) {
		//Abs value isnt needed if you just flip it
		int score = (60 - birthDate.compare(st.birthDate)) + (40 - pref.compare(st.pref));

		if (score < 0) {
			return 0;
		} else if (score >= 100) {
			return 100;
		}
		if (gender != st.gender) {
			return 0;
		}
		return score;
	}
	}