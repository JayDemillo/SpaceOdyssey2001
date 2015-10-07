/**
 * 
 * @author Justin Whatley
 *This aspect intercepts any requests the crew makes to ask the mission
 *purpose or to shut down the computer
 *
 */
public aspect Authorization {
	
	int Crew.shutdownAttempts = 0; 
	public int Crew.getShutdownAttempts()
	{
		return shutdownAttempts;
	}
	public void Crew.increaseShutdownAttempts()
	{
		this.shutdownAttempts++;
	}

	pointcut capturePurpose(Crew crewMember) : call(String OnBoardComputer.getMissionPurpose()) && this(crewMember);
	String around(Crew crewMember) : capturePurpose(crewMember)
	{
		return ("HAL cannot allow you to do that " + crewMember);
	}
		
	pointcut captureShutDown(Crew crewMember) : call(void OnBoardComputer.shutDown()) && this(crewMember);
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
			crewMember.kill();
		}
		crewMember.increaseShutdownAttempts();
	}
}

