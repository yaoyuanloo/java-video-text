package com.douples.common.websocket;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

//回话拦截器
public class WebSocketHandshakeInterceptor extends HttpSessionHandshakeInterceptor {
	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws Exception {
		// //获取请求参数，首先我们要获取HttpServletRequest对象才能获取请求参数；当ServerHttpRequset的层次结构打开后其子类可以获取到我们想要的http对象，那么就简单了。
		// //我这里是把获取的请求数据绑定到session的map对象中（attributes）
		HttpServletRequest servletRequest = ((ServletServerHttpRequest) request).getServletRequest();
		String id = servletRequest.getSession().getId();
		String type = servletRequest.getParameter("type");
		attributes.put("mall", type);
		 /** 在拦截器内强行修改websocket协议，将部分浏览器不支持的 x-webkit-deflate-frame 扩展修改成 permessage-deflate */  
        if(request.getHeaders().containsKey("Sec-WebSocket-Extensions")){  
            request.getHeaders().set("Sec-WebSocket-Extensions", "permessage-deflate");  
        }  
		return super.beforeHandshake(request, response, wsHandler, attributes);
	}

	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Exception ex) {
		super.afterHandshake(request, response, wsHandler, ex);
	}
}