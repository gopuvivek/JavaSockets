
import java.io.StringWriter;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import javax.json.*;
import java.util.*;


@ServerEndpoint(value="/VitalCheckEndPoint",configurator=VitalCheckConfigurator.class)
public class VitalCheckEndPoint
{
static Set<Session> subscribers=Collections.synchronizedSet(new HashSet<Session>());
	

@OnOpen
public void handleOpen(EndpointConfig endpointconfig,Session userSession)
{
	String username = (String)endpointconfig.getUserProperties().get("username");
	userSession.getUserProperties().put("username",endpointconfig.getUserProperties().get("username"));
	userSession.getUserProperties().put("phone",endpointconfig.getUserProperties().get("phone"));
	
	subscribers.add(userSession);
}


@OnMessage
public void handleMessage(String message,Session userSession)
{
   String username=(String)userSession.getUserProperties().get("username");
   String phone = (String)userSession.getUserProperties().get("phone");
   System.out.println(username+" "+phone);
   System.out.println(message);
   if(username!=null && !username.equals("doctor"))
    {
       subscribers.stream().forEach(x->{
            try {
	 if(x.getUserProperties().get("username").equals("doctor"))
	 {
	     if(Integer.parseInt(message)< 90)
		 x.getBasicRemote().sendText(buildJSON(username+","+phone,message));
	  }
	}
	catch(Exception e)
	{
	   e.printStackTrace();
	 }
	 });
	 }
   else if(username!=null && username.equals("doctor"))
    {
     String[] messages=message.split(",");
     String patient=messages[0];
     String ph = messages[1];
     String subject=messages[2];
     subscribers.stream().forEach(x->{
     try 
    {
        if(subject.equals("ambulance"))
        {
           if(x.getUserProperties().get("username").equals(patient))
	 {
	 x.getBasicRemote().sendText(buildJSON("doctor","has summoned an ambulance"));
	 }
           else if(x.getUserProperties().get("username").equals("ambulance"))
	{
	 x.getBasicRemote().sendText(buildJSON(patient+","+ph,"Requires an ambulance"));
	 }
          }
       else if(subject.equals("medication"))
         {
             if(x.getUserProperties().get("username").equals(patient))
	{
	 x.getBasicRemote().sendText(buildJSON("doctor",messages[3]+","+messages[4]));
	 }
	
          }
 }
 catch(Exception e)
 {
     e.printStackTrace();
 }
 });
 }
}

@OnClose
public void handleClose(Session userSession)
{
  subscribers.remove(userSession);
 }

 @OnError
  public void handleError(Throwable t)
  {	}
	
  
 private String buildJSON(String username,String message)
{
   JsonObject jsonObject=Json.createObjectBuilder().add("message",username+","+message).build();
   StringWriter stringWriter=new StringWriter();
   try(JsonWriter jsonWriter=Json.createWriter(stringWriter))
     {
         jsonWriter.write(jsonObject);
     }
   return stringWriter.toString();
 }

}