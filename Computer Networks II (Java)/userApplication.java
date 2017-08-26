/*	Niras Dimitris
	8057
	diminira@auth.gr
	Diktua II
*/

package networks2;

import java.net.*;
import java.util.Scanner;
import java.io.*;
import javax.sound.sampled.*;

public class userApplication {
	
	private static String clientPort = "48004";
	private static String serverPort = "38004";
	private static String echoCode = "E2449";
	private static String imageCode = "M3195";
	private static String soundCodeDPCM = "V3744T999";
	private static String soundCodeAQDPCM = "V3744AQF999";
	private static Scanner input;

	public static void main(String[] args) throws IOException, LineUnavailableException {
		
		System.out.println("Choose one option :\n"
				+ "1. Take response times from echo packets.\n"
				+ "2. Take temperature packets.\n"
				+ "3. Take camera image.\n"
				+ "4. Take DPCM sound.\n"
				+ "5. Take AQDPCM sound.\n"
				+ "6. Take ithakiCopter telemetry.");
		
		input = new Scanner(System.in);
		int choice = input.nextInt();
		
		switch (choice) {
		case 1: {
			echoPacket();
			break;
		}
		case 2: {
			echoPacketTemperature();
			break;
		}
		case 3: {
			imageReceive();
			break;
		}
		case 4: {
			soundDPCM();
			break;
		}
		case 5: {
			soundAQDPCM();
			break;
		}
		case 6: {
			ithakiCopter();
			break;
		}
		default: System.out.println("Sorry, i didn't understand!");		
		}
		
	}
	
	public static void echoPacket() throws IOException {
		
		int serverport, clientport;
		int cnt = 0;
		long endTime;
		long sendTime = 0;
		long receiveTime = 0;
		byte[] txbuffer, rxbuffer;
		String packetInfo;
		String message = "";
		String responseTime = "";
		
		PrintWriter resTime = new PrintWriter("responseTime.txt");
		PrintWriter msgs = new PrintWriter("msgs.txt");
		
		DatagramSocket s = new DatagramSocket();
		
		packetInfo = echoCode;
		txbuffer = packetInfo.getBytes();
		serverport = Integer.parseInt(serverPort);
		byte[] hostIP = { (byte)155 , (byte)207 , 18 , (byte)208 };
		InetAddress hostAddress = InetAddress.getByAddress(hostIP);
		
		DatagramPacket p = new DatagramPacket(txbuffer, txbuffer.length, hostAddress, serverport);
		
		clientport = Integer.parseInt(clientPort);
		DatagramSocket r = new DatagramSocket(clientport);
		
		r.setSoTimeout(3000);
		rxbuffer = new byte[32];
		
		DatagramPacket q = new DatagramPacket(rxbuffer, rxbuffer.length);
		
		endTime = System.currentTimeMillis() + 240000;
		
		while(System.currentTimeMillis() <= endTime) {		
			sendTime = System.currentTimeMillis();
			s.send(p);
			cnt++;
			
			try {
				r.receive(q);
				receiveTime = System.currentTimeMillis();
				message = new String(rxbuffer, 0, q.getLength());
			} catch (Exception x) {
				System.out.println(x);
			}
				
			responseTime = String.valueOf(receiveTime - sendTime);
			resTime.println(responseTime);
			msgs.println(message);
		}
		
		System.out.printf("\nNumber of received echo packets : %d", cnt);
		
		s.close();
		r.close();
		resTime.close();
		msgs.close();
		
	}
	
	public static void echoPacketTemperature() throws IOException {
		
		int serverport, clientport, i;
		int cnt = 0;
		byte[] txbuffer, rxbuffer;
		String packetInfo;
		String message = "";
		String echoTemperatureCode = "";
		
		PrintWriter tempMsgs = new PrintWriter("tempMsgs.txt");
		
		DatagramSocket s = new DatagramSocket();
		
		packetInfo = echoCode + "T";
		txbuffer = packetInfo.getBytes();
		serverport = Integer.parseInt(serverPort);
		byte[] hostIP = { (byte)155 , (byte)207 , 18 , (byte)208 };
		InetAddress hostAddress = InetAddress.getByAddress(hostIP);
		
		DatagramPacket p = new DatagramPacket(txbuffer, txbuffer.length, hostAddress, serverport);
		
		clientport = Integer.parseInt(clientPort);
		DatagramSocket r = new DatagramSocket(clientport);
		
		r.setSoTimeout(3000);
		rxbuffer = new byte[54];
		
		DatagramPacket q = new DatagramPacket(rxbuffer, rxbuffer.length);
		
		for (i=0; i<100; i++) {
			
			if (i<10) 
				echoTemperatureCode = echoCode + "T0" + String.valueOf(i);
			else
				echoTemperatureCode = echoCode + "T" + String.valueOf(i);
			
			txbuffer = echoTemperatureCode.getBytes();
			
			p.setData(txbuffer);
			p.setLength(txbuffer.length);
			
			s.send(p);
			cnt++;
			
			try {
				r.receive(q);
				message = new String(rxbuffer, 0, q.getLength());
			} catch (Exception x) {
				System.out.println(x);
			}
			
			tempMsgs.println(message);
		}
		
		System.out.printf("\nNumber of received temperature packets : %d", cnt);
		
		s.close();
		r.close();
		tempMsgs.close();
	
	}
	
	public static void imageReceive() throws IOException {
		
		int serverport, clientport;
		byte[] txbuffer, rxbuffer;
		
		FileOutputStream image = new FileOutputStream ("image.jpg");
		
		DatagramSocket s = new DatagramSocket();
		
		txbuffer = imageCode.getBytes();
		serverport = Integer.parseInt(serverPort);
		byte[] hostIP = { (byte)155, (byte)207, 18, (byte)208 };
		InetAddress hostAddress = InetAddress.getByAddress(hostIP);
		
		DatagramPacket p = new DatagramPacket(txbuffer, txbuffer.length, hostAddress, serverport);
		
		clientport = Integer.parseInt(clientPort);
		DatagramSocket r = new DatagramSocket(clientport);
		
		r.setSoTimeout(1000);
		rxbuffer = new byte[128];
		
		DatagramPacket q = new DatagramPacket(rxbuffer, rxbuffer.length);
		
		s.send(p);
		
		for(;;) {
			try {
				r.receive(q);
				image.write(rxbuffer);
				image.flush();
			} catch(Exception x) {
				System.out.println(x);
				break;
			}
		}
		
		r.close();
		s.close();
		image.close();
		
	}
	
	public static void soundDPCM() throws IOException, LineUnavailableException {
		
		int serverport, clientport;
		int i = 0;
		int bpp = 128;
		int soundPackets = 999;
		int samplesSize = 2*bpp*soundPackets;
		int[] soundSamples = new int[samplesSize];
		int[] soundClip = new int[samplesSize];
		byte[] txbuffer, rxbuffer;
		byte[] receivedSound = new byte[bpp*soundPackets];
		
		PrintWriter samples = new PrintWriter("SamplesDPCM.txt");
		PrintWriter samplesDiffs = new PrintWriter("SamplesDiffsDPCM.txt");
		
		DatagramSocket s = new DatagramSocket();
		
		txbuffer = soundCodeDPCM.getBytes();
		serverport = Integer.parseInt(serverPort);
		byte[] hostIP = { (byte)155, (byte)207, 18, (byte)208 };
		InetAddress hostAddress = InetAddress.getByAddress(hostIP);
		
		DatagramPacket p = new DatagramPacket(txbuffer, txbuffer.length, hostAddress, serverport);
		
		clientport = Integer.parseInt(clientPort);
		DatagramSocket r = new DatagramSocket(clientport);
		
		r.setSoTimeout(1000);
		rxbuffer = new byte[bpp];
		
		DatagramPacket q = new DatagramPacket(rxbuffer, rxbuffer.length);
		
		s.send(p);
		
		for(;;) {
			try {
				r.receive(q);
				for( int j=0; j<bpp; j++)
					receivedSound[i*bpp + j] = rxbuffer[j];
				i++;
			} catch (Exception x) {
				System.out.println(x);
				break;
			}
		}
		
		System.out.printf("\nNumber of received DPCM packets : %d", i);
		
		AudioFormat linearPCM = new AudioFormat(8000, 8, 1, true, false);
		SourceDataLine lineOut = AudioSystem.getSourceDataLine(linearPCM);
		lineOut.open(linearPCM, samplesSize); 
		
		for (i=0; i<bpp*soundPackets; i++) {
			int k = (int)receivedSound[i];
			soundSamples[2*i] = (((k >> 4) & 15) - 8);
			soundSamples[2*i + 1] = ((k & 15) - 8);
		}
		
		byte[] audioBufferOut = new byte[2*bpp*soundPackets];
		
		for (i=1; i<samplesSize; i++)
			soundClip[i] = soundSamples[i];
		
		audioBufferOut[0] = (byte)(2*soundClip[0]);
		for(i=1; i<samplesSize; i++) {
			soundClip[i] =  2*soundClip[i] + audioBufferOut[i-1];
			audioBufferOut[i] = (byte)soundClip[i];	
		}
		
		for(i=0; i<samplesSize; i++){
			samples.println(audioBufferOut[i]);
			samplesDiffs.println(soundSamples[i]);
		}
		
		lineOut.start();
		lineOut.write(audioBufferOut, 0, samplesSize);
		lineOut.stop();
		
		lineOut.close();
		s.close();
		r.close();
		samples.close();
		samplesDiffs.close();
		
	}

	public static void soundAQDPCM() throws IOException, LineUnavailableException {
		
		int serverport, clientport;
		int i = 0, cnt = 0;
		int bpp = 132;
		int soundPackets = 999;
		int samplesSize = 2*bpp*soundPackets;
		int lsb = 0;
		int msb = 0;
		int[] mean = new int[soundPackets];
		int[] step = new int[soundPackets];
		int[] soundSamples = new int[samplesSize];
		int[] soundClip = new int[samplesSize];
		byte[] txbuffer, rxbuffer;
		byte[] receivedSound = new byte[bpp*soundPackets];
		
		PrintWriter samples = new PrintWriter("SamplesAQDPCM.txt");
		PrintWriter samplesDiffs = new PrintWriter("SamplesDiffsAQDPCM.txt");
		PrintWriter means = new PrintWriter("means.txt");
		PrintWriter steps = new PrintWriter("steps.txt");
		
		DatagramSocket s = new DatagramSocket();
		
		txbuffer = soundCodeAQDPCM.getBytes();
		serverport = Integer.parseInt(serverPort);
		byte[] hostIP = { (byte)155, (byte)207, 18, (byte)208 };
		InetAddress hostAddress = InetAddress.getByAddress(hostIP);
		
		DatagramPacket p = new DatagramPacket(txbuffer, txbuffer.length, hostAddress, serverport);
		
		clientport = Integer.parseInt(clientPort);
		DatagramSocket r = new DatagramSocket(clientport);
		
		r.setSoTimeout(1000);
		rxbuffer = new byte[bpp];
		
		DatagramPacket q = new DatagramPacket(rxbuffer, rxbuffer.length);
		
		s.send(p);
		
		for(;;) {
			try {
				r.receive(q);
				for(int j=0; j<bpp; j++)
					receivedSound[i*bpp + j] = rxbuffer[j];
				i++;
			} catch (Exception x) {
				System.out.println(x);
				break;
			}
		}
		
		System.out.printf("\nNumber of received AQDPCM packets : %d", i);
		
		AudioFormat linearPCM = new AudioFormat(8000, 16, 1, true, false);
		SourceDataLine lineOut = AudioSystem.getSourceDataLine(linearPCM);
		lineOut.open(linearPCM, samplesSize); 
		
		for (i=0; i<soundPackets; i++) {   
			lsb = (int)receivedSound[bpp*i];
			msb = (int)receivedSound[bpp*i + 1];
			mean[i] = (256 * msb) + (lsb & 0x00FF);
			lsb = (int)receivedSound[bpp*i + 2];
			msb = (int)receivedSound[bpp*i + 3];
			step[i] = (256 * (msb & 0x00FF)) + (lsb & 0x00FF);
		}
		
		for(i=0; i<soundPackets; i++) {
			means.println(mean[i]);
			steps.println(step[i]);
		}
		
		for (i=0; i<soundPackets; i++) {
			for(int j=4; j<bpp; j++) {
				int k = (int)receivedSound[i*bpp + j];
				soundSamples[2*cnt] = (((k >> 4) & 15) - 8)*step[i];
				soundSamples[2*cnt + 1] = ((k & 15) - 8)*step[i];
				cnt++;
			}
		}
		
		byte[] audioBufferOut = new byte[512*soundPackets]; //512 = 128*2*soundPackets*2
			
		for(i=1; i<256*soundPackets; i++)
			soundClip[i] = soundSamples[i];
			
		for(i=0; i<soundPackets; i++) {
			for(int j=0; j<256; j++) {
				if(i==0 && j==0) continue;
					soundClip[i*256 + j] =  soundClip[i*256 + j] + soundClip[i*256 + j - 1];	
			}
		}
			
		for(i=0; i<256*soundPackets; i++){
			audioBufferOut[2*i] = (byte)(soundClip[i] & 0xFF);
			audioBufferOut[2*i + 1] = (byte)((soundClip[i] >> 8) & 0xFF);
		}
		
		for(i=0; i<256*soundPackets; i++) {
			samples.println(audioBufferOut[i]);
			samplesDiffs.println(soundSamples[i]);
		}
					
		lineOut.start();
		lineOut.write(audioBufferOut, 0, audioBufferOut.length);
		lineOut.stop();
		
		lineOut.close();
		s.close();
		r.close();
		samples.close();
		samplesDiffs.close();
		means.close();
		steps.close();
		
	}
	
	public static void ithakiCopter() throws IOException {
		
		int portNumber = 38048;
		byte[] addressArray = { (byte)155, (byte)207, 18, (byte)208 };
		InetAddress hostAddress = InetAddress.getByAddress(addressArray);
		
		PrintWriter copter = new PrintWriter("copter.txt");
		
		Socket s = new Socket(hostAddress, portNumber);
		s.setSoTimeout(1000);
		InputStream in = s.getInputStream();
		OutputStream out = s.getOutputStream();
		
		for(;;) {
			try {
				out.write("AUTO FLIGHTLEVEL=150 LMOTOR=125 RMOTOR=125 PILOT \r\n".getBytes());
				int k = in.read();
				System.out.print((char)k);
				copter.print((char) k);
			} catch(Exception x) {
				System.out.println(x);
				break;
			}
		}
		
		s.close();
		copter.close();
		
	}
}
