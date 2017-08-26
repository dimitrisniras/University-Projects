package diktua1;

import ithakimodem.Modem;
import java.io.*;
import java.util.Scanner;

public class userApplication {
	
	private static Modem modem;
	private static int speed = 80000;
	private static int timeout = 2000;
	private static String echoRequestCode = "E8883\r";
	private static String imageFreeRequestCode = "M7415\r";
	private static String imageErrorRequestCode = "G0350\r";
	private static String GPSrequestCode = "P7438";
	private static String R = "R=1050050\r";
	private static String ACKrequestCode = "Q3845\r";
	private static String NACKrequestCode = "R6539\r";
	private static Scanner input;

	public static void main(String[] args) throws IOException {	
		
		System.out.println("Choose one option :\n"
				+ "1. Take response times from echo packets.\n"
				+ "2. Take camera image without errors.\n"
				+ "3. Take GPS image.\n"
				+ "4. Take camera image with errors.\n"
				+ "5. Take response times from echo packets with errors.\n"
				+ "6. Take ithakiCopter telemetry");
		
		input = new Scanner(System.in);
		int choice = input.nextInt();
		
		initialize();
		
		switch (choice) {
		case 1: {
			echoPacket();
			break;
		}
		case 2: {
			errorFreeImage();
			break;
		}
		case 3: {
			GPSsystem();
			break;
		}
		case 4: {
			errorImage();
			break;
		}
		case 5: {
			ARQpacket();
			break;
		}
		case 6: {
			ithakiCopter();
			break;
		}
		default: System.out.println("Sorry, i didn't understand!");		
		}
		
		modem.close();
	} 
	
	public static void initialize () {
		modem = new Modem();
		modem.setSpeed(speed);
		modem.setTimeout(timeout);
		
		modem.write("atd2310ithaki\r".getBytes());
		
		for(;;) {
			try {
				if (modem.read() == -1) break;
			} catch (Exception x) {
				break;
			}
		}
	}
	
	public static void echoPacket () throws IOException {
		int cnt = 0;
		long endTime = System.currentTimeMillis() + 240000;
		long receiveTime = 0;
		long sendTime = 0;
		String responseTime = "";
		String echoData = "";
		
		PrintWriter resTime = new PrintWriter("C:/Users/lebro/Documents/workspace/diktua1/responseTime.txt");
		
		while (System.currentTimeMillis() <= endTime) {
			int k = 0;
			sendTime = System.currentTimeMillis();
			
			modem.write(echoRequestCode.getBytes());
			
			for(;;) {
				try {
					k = modem.read();
					System.out.print((char) k);
					echoData += (char) k;
					
					if (echoData.endsWith("PSTOP")) {
						cnt += 1;
						receiveTime = System.currentTimeMillis();
						responseTime = String.valueOf(receiveTime - sendTime);
						resTime.println(responseTime);
						echoData = "";
						break;
					}
				} catch (Exception x) {
					break;
				}
			}
		}
		
		System.out.printf("\nNumber of sended Packets : %d",cnt);
		
		resTime.close();
	}
	
	
	public static void errorFreeImage () throws IOException {
		int k;
		
		modem.write(imageFreeRequestCode.getBytes());
		
		FileOutputStream image = new FileOutputStream ("C:/Users/lebro/Documents/workspace/diktua1/errorFreeImage.jpg");
		
		for(;;) {
			try {
				k = modem.read();
				if (k == -1) break;
				image.write((byte) k);
				image.flush();
			} catch (Exception x) {
				break;
			}
		}
		
		image.close();
	}
	
	
	public static void GPSsystem () throws IOException {
		int k;
		int j = 0;
		int longsec;
		int latsec;
		int dots = 6;
		int secs = 4;
		String data = "";
		String tempCode = GPSrequestCode;
		String[] commas;
		String[] longitudes = new String[dots];
		String[] latitudes = new String[dots];
		
		// Send GPS code implement with R = .. in order to get the coordinates
		modem.write((GPSrequestCode + R).getBytes());
		
		for(;;) {
			try {
				k = modem.read();
				if (k == -1) break;
				data += (char) k;
			} catch (Exception x) {
				break;
			}
		}
		
		// Split the coordinates in commas 
		commas = data.split(",");
		
		// Separate latitudes and longitudes and take samples per secs seconds (i += secs*14)
		for (int i=2; i<commas.length; i+=(secs*14)) {
			if (j == dots) break;
			latitudes[j] = commas[i];
			longitudes[j] = commas[i+2];
			j++;
		}
		
		// Make longitudes and latitudes in degrees minutes seconds format
		for (int i=0; i<latitudes.length; i++) {
			tempCode += "T=";
			tempCode += longitudes[i].substring(1,3);
			tempCode += longitudes[i].substring(3,5);
			longsec = Integer.parseInt(longitudes[i].substring(6,10));
			longsec = (int) (longsec * 0.006);
			tempCode += longsec + "";
			tempCode += latitudes[i].substring(0,2);
			tempCode += latitudes[i].substring(2,4);
			latsec = Integer.parseInt(latitudes[i].substring(5,9));
			latsec = (int) (latsec * 0.006);
			tempCode += latsec + "";
		}
		tempCode += "\r";
		
		FileOutputStream gps = new FileOutputStream("C:/Users/lebro/Documents/workspace/diktua1/GPSimage.jpg");
		
		// Write in modem the GPS code implemented with T=.. to take GPS image
		modem.write(tempCode.getBytes());
		System.out.print(tempCode);
		
		for(;;) {
			try {
				k = modem.read();
				if (k == -1) break;
				gps.write((byte) k);
				gps.flush();
			} catch (Exception x) {
				break;
			}
		}
		
		gps.close();
	}
	
	
	public static void errorImage () throws IOException {
		int k;
		
		modem.write(imageErrorRequestCode.getBytes());
		
		FileOutputStream image = new FileOutputStream ("C:/Users/lebro/Documents/workspace/diktua1/errorImage.jpg");
		
		for(;;) {
			try {
				k = modem.read();
				if (k == -1) break;
				image.write((byte) k);
				image.flush();
			} catch (Exception x) {
				break;
			}
		}
		
		image.close();
	}
	
	
	public static void ARQpacket () throws FileNotFoundException {
		int k;
		int cnt = 0;
		int errors = 0;
		boolean equal = true;
		long endTime = System.currentTimeMillis() + 240000;
		long receiveTime = 0;
		long sendTime = 0;
		String responseTime = "";
		String echoData = "";
		String[] spaces;
		
		PrintWriter resTime = new PrintWriter("C:/Users/lebro/Documents/workspace/diktua1/responseWithErrorTime.txt");
		PrintWriter error = new PrintWriter ("C:/Users/lebro/Documents/workspace/diktua1/errors.txt");
		
		while (System.currentTimeMillis() <= endTime) {
			// if package send right then take next package with ACK code else re-sent the previous package
			if (equal) {
				cnt += 1;
				sendTime = System.currentTimeMillis();
				modem.write(ACKrequestCode.getBytes());
			}
			else {
				modem.write(NACKrequestCode.getBytes());
				errors += 1;
			}
			for (;;) {
				try {
					k = modem.read();
					echoData += (char) k;
					System.out.print((char) k);
					
					if (echoData.endsWith("PSTOP")) {
						spaces = echoData.split("\\s+");
						// checks if package sent right
						equal = errorCheck (spaces[4] , spaces[5]);
						
						if (equal) {
							receiveTime = System.currentTimeMillis();
							responseTime = String.valueOf(receiveTime - sendTime);
							resTime.println(responseTime);
							error.println(errors);
							errors = 0;
						}
						echoData = "";
						break;
					}
				} catch (Exception x) {
					break;
				}
			}
		}
		
		System.out.printf("\nNumber of sended Packets : %d\n",cnt);
		
		resTime.close();
		error.close();
	}
	
	
	public static boolean errorCheck (String array , String FCS) {
		int xor;
		int fcs = Integer.parseInt(FCS);
		xor = array.charAt(1) ^ array.charAt(2);
		
		for (int i=3; i<17; i++) {
			xor = xor ^ array.charAt(i);
		}
		
		return (xor == fcs);
	}
	
	public static void ithakiCopter() throws IOException {
		int k;
		
		modem.open("ithakicopter");
		
		FileOutputStream text = new FileOutputStream ("C:/Users/lebro/Documents/workspace/diktua1/ithakiCopter.txt");
		
		for(;;) {
			try {
				k = modem.read();
				if (k == -1) break;
				text.write((byte) k);
				text.flush();
				} catch (Exception x) {
				break;
			}
		}
		
		text.close();
	}
}