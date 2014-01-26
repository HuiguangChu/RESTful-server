package jaxrs;

import javax.ws.rs.GET;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.Path;
import javax.ws.rs.core.MediaType;



//The Java class will be hosted at the URI path //"/database"
@Path("/database")
public class Resource {
 // The Java method will process HTTP GET requests
// The Java method will produce content identified by the MIME Media
 // type "text/plain"
  @Produces(MediaType.TEXT_PLAIN)
  @Path("{Info}")
  @GET
  //method must have a return value to the httpclient get request
  public String  getClichedMessage (@PathParam("Info") String Name) { 
	  
	  return  Service.getinformation(Name);
	
} 
  
  }





