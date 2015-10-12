/**
 * Logger.aj
 * @author Justin Whatley #29472029
 * COMP 348 Assignment 1
 *
 * Keeps a log of all important messages that are sent within the system. These include messages
 * sent to the OnBoardComputer and the LifeSupport status of the Crew, and are displayed with the 
 * system time in milliseconds 
 */

import java.io.BufferedWriter;
import java.io.FileWriter;

public aspect Logger {

	String logMessage = "";
	String fileName = "SystemLog.txt";
	
	/**
	 * This pointcut captures all calls made to OnBoardComputer, excluding anything that might
	 * have been initiated in logger for safety. This also passes the message sender's (crewMember) 
	 * context and message target's (OnBoardComputer) context and publishes them
	 * 
	 * @param crewMember of type Crew
	 * @param system of type OnBoardComputer
	 */
	pointcut events(Crew crewMember, OnBoardComputer system) : 
		call(* OnBoardComputer.*(..)) &&!within(Logger) 
		&& this(crewMember) && target(system);

	/**
	 * This advice outputs informations related to calls to the OnBoardComputer of 
	 * getStatus, getDate, getMission and shutDown, to a txt file 
	 * 
	 * @param crewMember of type Crew
	 * @param system of type OnBoardComputer
	 */
	before(Crew crewMember, OnBoardComputer system): events(crewMember, system)
	{
		String logMessage = " : " + thisJoinPoint.getThis().getClass().getSimpleName(); //sets system (caller) name
		logMessage += " : " + system.name; //sets system (caller) name
		
		//Sets output message to getStatus, getDate, getMissionPurpose and shutDown based on 
		//method from signature parsing
		String methodFromPoint = thisJoinPoint.getSignature().toString();
		logMessage +=  " : " + methodFromPoint.substring(methodFromPoint.lastIndexOf('.') + 1, methodFromPoint.lastIndexOf('(')) +"\n";
		
		//outputs string to the system log file
		writeOutput(fileName, logMessage);
	}

	/**
	 * This pointcut captures executions of the getLifeStatus() function of type Crew. This also
	 * passes the message sender's (crewMember) context and publishes them
	 * @param crewMember of type Crew
	 */
	pointcut lifeSupportStatus() : 
		execution(boolean Crew.getLifeStatus()) || call(void Crew.kill());

	/**
	 * This advice stops outputs informations related to Crew lifeSupportStatus to a txt file 
	 * @param crewMember of type Crew
	 */
	after(): lifeSupportStatus()
	{
		//Stores Class that is calling the function (can be either in LifeSupport or Logger
		String sourceLocation = thisJoinPoint.getSourceLocation().toString();
		String logMessage = " : " + sourceLocation.substring(0, sourceLocation.lastIndexOf('.'));
		
		logMessage += " : " + thisJoinPoint.getTarget().toString(); //Stores crewMember name to a string
		
		String methodFromPoint = thisJoinPoint.getSignature().toString(); //Stores function name to a string
		logMessage +=  " : " + methodFromPoint.substring(methodFromPoint.lastIndexOf('.') + 1, methodFromPoint.lastIndexOf('(')) +"\n";
		
		//outputs string to the system log file
		writeOutput(fileName, logMessage);
	}
	
	
	/**
	 * Writes the passed output message to the passed text file name with mod1000 timestamps
	 * @param fileName is the name of the file to output to
	 * @param message is the String message to write to the file
	 */
	public static void writeOutput(String fileName, String message)
	{
		BufferedWriter writer = null;
		try {
			writer = new BufferedWriter(new FileWriter(fileName, true));
			//Sets line output time equivalent to the current system time mod1000 and output logString
			writer.write(System.currentTimeMillis()%1000 + message);
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
