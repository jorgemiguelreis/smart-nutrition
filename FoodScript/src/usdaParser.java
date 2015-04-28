import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public class usdaParser {

	private static final String[] KEYS = {"zHT0f6iTKiI3c59cx7Pug7XnEi3jK3vmRgXiOKLa",
										"VRVHWRNVEGUNSlF7v2F21uMlUfoXX0pHt3MIONUU",
										"u62FEgl078Lthgw8ov23d3QREbCVlU8KwlHwPEc2",
										"urjeZmM7qCPHrFEFwhplOA1avkudELrILhWuH1eB",
										"iWxc8rfklx9EndzTPyzaXxk72LchPXj1Ng4KvVxs",
										"76gSlVRXUNi9DiZvXCdH5WDT8mZR3aNqrIWxZ2t9",
										"4AyyirEOWoLnh7cfBmN7k4njsVaCKuOQu6rCwQTg"
										};
	private static int count1 = 0;
	private static int count2 = 0;
	private static int keynr = 0;
	
	private static void newKey() {
		if(keynr == KEYS.length-1)
			keynr = 0;
		else
			keynr++;
	}

	public static void main(String[] args) throws TransformerException, IOException {

		/*	
		File stylesheet = new File(args[0]); //XSLT
		File datafile = new File(args[1]); //XML

		TransformerFactory factory = TransformerFactory.newInstance();
		Source xslt = new StreamSource(new File("transform.xslt"));
		Transformer transformer = factory.newTransformer(xslt);

		Source text = new StreamSource(new File("input.xml"));
		transformer.transform(text, new StreamResult(new File("output.xml")));
		 */
		
		TransformerFactory factory = TransformerFactory.newInstance();
		Source xslt = new StreamSource(new File("simple_transform.xsl"));
		Transformer transformer = factory.newTransformer(xslt);
		//File f = new File("output.xml");
		//StreamResult r = new StreamResult(f);

		//StringBuilder s = new StringBuilder();

		PrintWriter out = new PrintWriter("output.xml", "UTF-8");
		out.println("<foods>");
		//String result = "";
		for(Integer i = 10000;i < 16000; i++) {
			String ndbo = String.format("%05d", i);
			System.out.println(ndbo);
			//s.append(request(ndbo));
			String res = request(ndbo);
			if(!res.equals("")){
				//System.out.println(res);
				//Source text = new StreamSource(res);
				StringReader reader = new StringReader(res);
				StringWriter writer = new StringWriter();
				transformer.transform(new StreamSource(reader), new StreamResult(writer));
				out.println(writer.toString());
			}
		}
		out.println("</foods>");
		out.close();
		//Source text = new StreamSource(s.toString());

		//PrintWriter writer = new PrintWriter("output.xml", "UTF-8");
		//writer.print(result);
		System.out.println(count1+" - "+count2);

	}

	public static String request(String ndbno) throws IOException {

		String request = "http://api.nal.usda.gov/usda/ndb/reports/?ndbno="+ndbno+"&type=b&format=xml&api_key="+KEYS[keynr];

		URL url;
		HttpURLConnection conn;
		BufferedReader rd;
		String line;
		String result = "";
		try {
			url = new URL(request);
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			int responseCode = conn.getResponseCode();
			System.out.println("Response code: "+responseCode);
			if(responseCode == 429) {
				newKey();
				request(ndbno);
			}
			else if(responseCode == 200) {
				//System.out.println("Ok");
				count1++;
				rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				while ((line = rd.readLine()) != null) {
					result += line+"\n";
				}
				rd.close();
			}
			else {
				count2++;
				//System.out.println("fail");
			}

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//System.out.println(result);
		return result;
	}
	

}
