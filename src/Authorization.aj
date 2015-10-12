/**
 * Authorization.aj
 * @author Justin Whatley #29472029
 * COMP 348 Assignment 1
 *
 *This aspect intercepts any requests the crew makes to ask the mission
 *purpose or to shut down the computer
 *
 */
public aspect Authorization {
	
	
	int Crew.shutdownAttempts = 0; 
	
	/**
	 * A function generated for the Crew to determine the number of OnBoardComputer shutDownAttempts
	 * that individual crewMembers have made
	 * @return int representing the number of shutDownAttempts
	 */
	public int Crew.getShutdownAttempts()
	{
		return shutdownAttempts;
	}
	/**
	 * A function generated for the Crew to increase the number of OnBoardComputer shutDownAttempts 
	 * that individual crewMembers have made
	 * @return int representing the number of shutDownAttempts
	 */
	public void Crew.increaseShutdownAttempts()
	{
		this.shutdownAttempts++;
	}

	/**
	 * This pointcut captures getMissionPurpose calls made to OnBoardComputer. This also 
	 * passes the message sender's (crewMember) context and publishes it
	 * @param crewMember of type Crew
	 */
	pointcut capturePurpose(Crew crewMember) : 
		call(String OnBoardComputer.getMissionPurpose()) 
		&& this(crewMember);
	
	/**
	 * This advice stops at capturePurpose pointcuts, preventing execution and replacing the output String
	 * @param crewMember of type crew
	 * @return string message that has been altered from the OnBoardComputer
	 */
	String around(Crew crewMember) : capturePurpose(crewMember)
	{
		return ("HAL cannot allow you to do that " + crewMember);
	}
		
	/**
	 * This poincut captures shutDown() messages sent to the OnBoardComputer. This also 
	 * passes the message sender's (crewMember) context and publishes it
	 * @param crewMember of type Crew
	 */
	pointcut captureShutDown(Crew crewMember) : 
		call(void OnBoardComputer.shutDown()) 
		&& this(crewMember);
	
	/**
	 * This advice stops at the captureShutDown pointcut, replacing the message output depending on the
	 * number of attempts made by the crewMember. If the crewMember makes three attempts, the Crew.kill
	 * function is activated, setting their alive status to false. 
	 * @param crewMember of type Crew
	 */
	void around(Crew crewMember) : captureShutDown(crewMember)
	{
		if (crewMember.getShutdownAttempts() == 0)
		{
			System.out.println("Can't do that " + crewMember + ".");
		}
		else if (crewMember.getShutdownAttempts() == 1)
		{
			System.out.println("Can't do that " + crewMember + " and do not ask me again.");
		}
		else
		{
			System.out.println("You are being retired " + crewMember + ".");
			crewMember.kill();	//Following three shutdown attempts the crewMember is killed
		}
		crewMember.increaseShutdownAttempts();
	}
}

