				
package android.jaxrs;
import android.app.Activity;
import android.os.Bundle;
import android.os.StrictMode;
import android.widget.TextView;

import java.io.IOException;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;

import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

public class AndroidJAXRSClient extends Activity {
	
	
	private TextView jaxrs;

     /** Called when the activity is first created. */
     @Override
     public void onCreate(Bundle savedInstanceState) {
    	 
    	 StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()     
    	         .detectDiskReads()     
    	         .detectDiskWrites()     
    	        .detectNetwork()   // or .detectAll() for all detectable problems     
    	        .penaltyLog()     
    	        .build());     
           //设置虚拟机的策略 
    	 //set up the virtual machine policy
              StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()     
    	                .detectLeakedSqlLiteObjects()     
    	                //.detectLeakedClosableObjects()     
    	                .penaltyLog()     
    	                 .penaltyDeath()     
    	                .build());  

              super.onCreate(savedInstanceState);
          setContentView(R.layout.main);
         jaxrs = (TextView) findViewById(R.id.jaxrs);

 try {
        	  
        	  //1.创建HTTPClient的实例
        	  //1.set up object  
        	  HttpClient httpclient = new DefaultHttpClient();
        	  //2.创建某种连接的方法
        	  //creating the method(get ,post,update,delete)
               HttpGet request = new HttpGet(
                  "http://128.39.42.159:8080/AndroidJAX-RS/jaxrs/database/Info");
//怎么发送带参数的request,服务器怎么解析参数类型
               //request.addHeader("Accept", "text/html");
             	//request.addHeader("Accept", "text/xml");
               request.addHeader("Accept","text/plain");
               //3.调用第一步创建好的实例（httpclient）的execute方法来执行第二步中创建好的方法实例（request）
               //3.invoke execute method of the object created in first step to execute the request 
               HttpResponse response = httpclient.execute(request);
               //4.读response
               
               //4.read response
               HttpEntity entity = response.getEntity();
               String result =EntityUtils.toString(entity);  
                 jaxrs.setText(result);  

               //InputStream instream = entity.getContent();
               //String jaxrsmessage = read(instream);
               //设置在textview的内容
                 //jaxrs.setText(jaxrsmessage);
          } catch (ClientProtocolException e) {
        	//发生致命的异常，可能是协议不对或者返回的内容有问题
        	   System.out.println("Please check your provided http address!");

             e.printStackTrace();
          } catch (IOException e) {
               e.printStackTrace();
          } 
          }

    

}
