package com.douples.common.websocket;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.douples.facade.guessFacade.GuessFacade;
import com.douples.framework.util.PageData;

import net.sf.json.JSONObject;

public class LiveWebSocketHandler extends TextWebSocketHandler {
	private static final Map<String, WebSocketSession> sessions = new HashMap<String, WebSocketSession>();
	private static final Map<String, Thread> threads = new HashMap<String, Thread>();
	private Thread polingVisualization = null;
	// 用户标识
	private static final String CLIENT_ID = "sessionId";
	
//	private static GuessFacade guessFacade = ApplicationContextHelper.getBean(GuessFacade.class);
	public static LiveWebSocketHandler testUtils;
	
	@Autowired
	private  GuessFacade guessFacade;

	// 在方法上加上注解@PostConstruct，这样方法就会在Bean初始化之后被Spring容器执行（注：Bean初始化包括，实例化Bean，并装配Bean的属性（依赖注入））。
	@PostConstruct	
	public void init() {
		testUtils = this;
	}


	//连接
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		Object u = session.getHandshakeAttributes().get("mall");//用户
		if (u != null) {
			sessions.put(u.toString(), session);
			System.out.println("加入websocket"+session.getId());
		}
		super.afterConnectionEstablished(session);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
		Thread thread = threads.get(session.getId());
		if (thread != null) {
			thread.interrupt();
			try {
				thread.join();
				threads.remove(session.getId());
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		sessions.remove(session.getId());
		sessions.remove(CLIENT_ID);
		polingVisualization = null;
		try {
			super.afterConnectionClosed(session, status);
		} catch (Exception e) {
		}
	}

	// //这里是处理前端发送的消息以及返回给前端的数据
	// //可以从session里面获取attributes，
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		super.handleTextMessage(session, message);
		System.out.println("这里是处理前端发送的消息以及返回给前端的数据");
	}

	private Object polingVisualization(WebSocketSession session, TextMessage message, Integer universalid) throws IOException {
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("status", "1");
		String dataStr = JSONObject.fromObject(dataMap).toString();
		TextMessage returnMessage = new TextMessage(dataStr);
		session.sendMessage(returnMessage);
		return "123333";
	}

	/**
	 * 发送数据到前端
	 * 
	 * @param universalid
	 * @param sessionId
	 */
	public synchronized  void sendNewProductDatas(PageData pd) {
		List<PageData> list = new ArrayList<PageData>();
		String dataStr = "";
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		try {
			dataMap.put("msg", pd.get("message"));
			dataMap.put("result", true);
		} catch (Exception e1) {
			e1.printStackTrace();
			dataMap.put("result", false);
		}
		dataStr = JSONObject.fromObject(dataMap).toString();
		
		TextMessage returnMessage = new TextMessage(dataStr);
		
		WebSocketSession webSocketSession = sessions.get(pd.get("u"));
		if (webSocketSession != null && webSocketSession.isOpen()) {
			try {
				System.out.println(returnMessage);
				webSocketSession.sendMessage(returnMessage);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}