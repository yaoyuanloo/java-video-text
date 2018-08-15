package com.douples.common.websocket;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
@EnableWebMvc
public class WebSocketConfig implements WebSocketConfigurer {

	public void registerWebSocketHandlers(WebSocketHandlerRegistry webSocketHandlerRegistry) {
		// //这里的url要与页面的url一致
		webSocketHandlerRegistry.addHandler(myHandler(), "/WebSocket/WebSocket.do")
				.addInterceptors(new WebSocketHandshakeInterceptor());
		// //至于这里为什么要加info，我遇见的情况是，当我使用sockjs来代替websocket时，连接的后面会自动加上info
		webSocketHandlerRegistry.addHandler(myHandler(), "/sockjs/WebSocket/info")
				.addInterceptors(new WebSocketHandshakeInterceptor()).withSockJS();
	}

	@Bean
	public WebSocketHandler myHandler() {
		return new LiveWebSocketHandler();
	}

}