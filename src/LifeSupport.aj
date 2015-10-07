

/**
 * 
 * @author Justin Whatley
 *
 * Extends the class Crew with a member variable to indicate whether the crew member is alive or dead and 
 * the appropriate accessor and mutator. 
 */

public aspect LifeSupport {
	
	//in order to ensure that message from crew are not received
	declare precedence: Logger, LifeSupport, Authorization;

	private boolean Crew.alive = true;

	
	public void Crew.kill()
	{
		this.alive = false;
	}
	
	public boolean Crew.getLifeStatus()
	{
		return alive;
	}
	
	pointcut captureDeadCalls1(Crew crewMember) :
		call(String OnBoardComputer.*(..)) 
		&& !call(* OnBoardComputer.shutDown(..))
		&& this(crewMember);
	
	String around(Crew crewMember) : captureDeadCalls1(crewMember)
	{
		if (crewMember.getLifeStatus() == true)
		{
			return proceed(crewMember);
		}
		return "";
	}
	
	pointcut captureDeadCalls2(Crew crewMember) :	
		call(void OnBoardComputer.shutDown(..))
		&& this(crewMember);
	
	void around(Crew crewMember) : captureDeadCalls2(crewMember)
	{
		if (crewMember.getLifeStatus() == true)
		{
			proceed(crewMember);
		}
	}

}
