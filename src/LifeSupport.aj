

/**
 * LifeSupport.aj
 * @author Justin Whatley #29472029
 * COMP 348 Assignment 1
 *
 * Extends the class Crew with a member variable to indicate whether the crew member is alive or dead and 
 * the appropriate accessor and mutator. 
 */

public aspect LifeSupport {
	
	//precedence ensure the order of captures matches the desired output
	declare precedence: Logger, LifeSupport, Authorization;

	private boolean Crew.alive = true;	

	/**
	 * A function generated for the Crew that can be called to kill the crewMember
	 */
	public void Crew.kill()
	{
		this.alive = false;
	}
	/**
	 * A function generated for the Crew that can be called to determine whether the members are alive
	 * or not
	 * @return a boolean representing the lifeStatus of the crewMember
	 */
	public boolean Crew.getLifeStatus()
	{
		return alive;
	}
	
	/**
	 * This pointcut captures messages sent to the OnBoardComputer class with return type String. 
	 * @param crewMember of type Crew
	 */
	pointcut captureDeadStrings(Crew crewMember):
		call(String OnBoardComputer.*(..)) 
		&& this(crewMember);
	
	/**
	 * This advice stops at captureDeadStrings pointcuts, preventing the call from continuing unless the
	 * the crewMember of type Crew is alive
	 *  
	 * @param crewMember of type Crew
	 */
	String around(Crew crewMember) : captureDeadStrings(crewMember)
	{
		if (crewMember.getLifeStatus() == true)
		{
			return proceed(crewMember);
		}
		return "";
	}
	
	/**
	 * This pointcut captures messages sent to the OnBoardComputer class with no return type. 
	 * 
	 * @param crewMember of type Crew
	 */
	pointcut captureDeadVoids(Crew crewMember) :	
		call(void OnBoardComputer.shutDown(..))
		&& this(crewMember);
	
	/**
	 * This advice stops at captureDeadVoids pointcuts, preventing the call from continuing unless the
	 * the crewMember of type Crew is alive
	 *  
	 * @param crewMember of type Crew
	 */
	void around(Crew crewMember) : captureDeadVoids(crewMember)
	{
		if (crewMember.getLifeStatus() == true)
		{
			proceed(crewMember);
		}
	}

}
