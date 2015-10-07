/**
 * @author Justin Whatley
 *
 * Keeps a log of all messages that are sent within the system. These critical messages
 * are displayed with the system time in milliseconds 
 */

import java.io.BufferedWriter;
import java.io.FileWriter;

public aspect Logger {

	String logMessage = "";
	String fileName = "out.txt";

	pointcut events(Crew crewMember, OnBoardComputer system) : 
		call(* OnBoardComputer.*(..)) &&!within(Logger) 
		&& this(crewMember) && target(system)
		&& !cflow(execution(* java.*.*.*(..)));

	before(Crew crewMember, OnBoardComputer system): events(crewMember, system)
	{
		String joinPointInfo = ""+ thisJoinPoint;
		//System.out.println(">>> " + joinPointInfo);
		String logMessage = "" + (System.currentTimeMillis()%1000);
		logMessage += " : " + thisJoinPoint.getThis().getClass().getSimpleName();
		logMessage += " : " + system.name + " : "; //prints system name
		
		//Sets output message for getStatus, getDate, getMissionPurpose and shutDown joinPoints
		if (joinPointInfo.equals("call(String OnBoardComputer.getStatus())"))
			logMessage += "getStatus\n";
		else if (joinPointInfo.equals("call(String OnBoardComputer.getDate())"))
			logMessage += "getDate\n";
		else if (joinPointInfo.equals("call(String OnBoardComputer.getMissionPurpose())"))
			logMessage += "getMissionPurpose\n";
		else if (joinPointInfo.equals("call(void OnBoardComputer.shutDown())"))
			logMessage += "shutDown\n";
		else 
			logMessage += "Unrecognized call";
		
		//System.out.println(logMessage);	
		writeOutput(fileName, logMessage);
	}

	pointcut lifeSupportStatus(Crew crewMember) : 
		execution(boolean Crew.getLifeStatus())
		&& this(crewMember); 

	after(Crew crewMember): lifeSupportStatus(crewMember)
	{
		String logMessage = "" + (System.currentTimeMillis()%1000);
		logMessage += " : LifeSupport";
		logMessage += " : " + crewMember.name + " : getLifeStatus\n";
		
		//System.out.println(logMessage);	
		writeOutput(fileName, logMessage);
	}
	
	pointcut killingAuthorization(Crew crewMember) : 
		execution(void Crew.kill())
		&& this(crewMember); 

	after(Crew crewMember): killingAuthorization(crewMember)
	{
		String logMessage = "" + (System.currentTimeMillis()%1000);
		logMessage += " : Authorization";
		logMessage += " : " + crewMember.name + " : kill\n";
		
		//System.out.println(logMessage);	
		writeOutput(fileName, logMessage);
	}



	/**
	 * Writes the passed output message to the passed text file name
	 * @param fileName is the name of the file to output to
	 * @param message is the String message to write to the file
	 */
	public static void writeOutput(String fileName, String message)
	{
		BufferedWriter writer = null;
		try {
			writer = new BufferedWriter(new FileWriter(fileName, true));
			writer.write(message);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			try{
				writer.close();
			}
			catch (Exception e) {}
		}
	}

	







}
