package com.douples.controller.rtc;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

public class WebRTCRoomManager {

	private static final Map<String,WebRTCSimpleRoom> provider = new HashMap<String,WebRTCSimpleRoom>();
	
	//创建房间
	public static void createRoom(String roomKey){
		WebRTCSimpleRoom room = provider.get(roomKey);
		if(room == null){
			provider.put(roomKey, room);
		}
	}
	
	
	//通信人加入房间
	public static void addUser(String roomKey,String user){
		WebRTCSimpleRoom room = provider.get(roomKey);
		if(room == null){
			room = new WebRTCSimpleRoom(roomKey,user);//创建房间  加入用户
			provider.put(roomKey, room);
			System.out.println(user+" 创建了room : " + roomKey);
		}else{
			if(user.equals(room.getUser1())||user.equals(room.getUser2())){//房间已经存在此用户已加入
			}else{//房间不存在此用户     则加入
				room.addUser(user);
				System.out.println(user+" 加入了 room : " + roomKey);
			}
		}
		
//		System.out.println("room : " + roomKey+" 的人有："+room.haveUser()+room);
//		System.out.println("："+room.getUser1());
//		System.out.println("："+room.getUser2());
	}
	
	public static void removeUser(String roomKey,String user){
		WebRTCSimpleRoom room = provider.get(roomKey);
		if(room != null){
			System.out.println("remove user : " + user);
			room.removeUser(user);
		}
		if(!room.haveUser()){
			provider.remove(roomKey);
			System.out.println("remove room : " + roomKey);
		}
//		System.out.println("room : " + roomKey+" 的人有："+room.haveUser()+room);
//		System.out.println("："+room.getUser1());
//		System.out.println("："+room.getUser2());
	}
	
	public static boolean haveUser(String key){
		WebRTCSimpleRoom room = provider.get(key);
		if(room != null){
			return room.haveUser();
		}else{
			return false;
		}
	}
	
	public static String getOtherUser(String roomKey,String user){
		WebRTCSimpleRoom room = provider.get(roomKey);
		if(room.haveUser()){
			return room.getOtherUser(user);
		}else{
			return null;
		}
	}
	
	/***
	 * 
	 * 房间是否已经满人
	 * 满人 则返回 true
	 * ******/
	public static boolean isRoomFull(String key){
		WebRTCSimpleRoom room = provider.get(key);
		if(room==null){
			return false;
		}
		if(StringUtils.isNotEmpty(room.getUser1())&&StringUtils.isNotEmpty(room.getUser2())){
			return true;
		}else{
			return false;
		}
	
	}
	
	
	/***
	 * 
	 * 判断房间进来的人是否 房间里的人
	 * 满人 则返回 true
	 * ******/
	public static boolean isRoomPerson(String key,String u){
		WebRTCSimpleRoom room = provider.get(key);
		if(room==null){
			return false;
		}
		if(StringUtils.isNotEmpty(room.getUser1())&&StringUtils.isNotEmpty(room.getUser2())){
			return true;
		}else{
			return false;
		}
	
	}
	
}
