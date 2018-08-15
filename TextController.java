package com.douples.controller.communication;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.URL;
import java.net.URLConnection;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.douples.common.util.wxutil.JsApi;
import com.douples.common.websocket.LiveWebSocketHandler;
import com.douples.controller.rtc.WebRTCRoomManager;
import com.douples.facade.common.CommonFacade;
import com.douples.facade.communicationFacade.CommunicationFacade;
import com.douples.framework.core.impl.BaseController;
import com.douples.framework.entity.IUser;
import com.douples.framework.util.PageData;
import com.google.gson.Gson;

import net.sf.json.JSONObject;

@Controller
@RequestMapping(value = "mobile/CommunicationController")
public class CommunicationController extends BaseController {
	@Resource(name = "communicationFacade")
	private CommunicationFacade communicationFacade;

	@Resource
	private JsApi jsApi;

	@Resource
	private CommonFacade commonFacade;

	/**
	 * 展示主界面
	 */
	@RequestMapping(value = "/CommunicationController_goMain")
	public ModelAndView goMain() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("livetv/client/CommunicationController_goMain");
		PageData pd = new PageData();
		pd = this.getPageData();

		Subject currentUser = SecurityUtils.getSubject();// wx id
		Session session = currentUser.getSession();
		IUser user = getApUser();
		String u = pd.get("u").toString();// 通话人
		String r = "";// 房间号
		if (pd.get("r") == null) {// 首次进来 新建房间
			r = this.get32UUID();
			mv.addObject("room", r);
		} else {// 带着房间号进来
			r = pd.get("r").toString();
		}
		
		//房间已经满人，则返回
		mv.addObject("isRoomFull", WebRTCRoomManager.isRoomFull(r));
		if(WebRTCRoomManager.isRoomFull(r)){
			return mv;
		}
		
		WebRTCRoomManager.addUser(r, pd.get("u").toString());// 创建房间 加入用户
		Integer initiator = 1;// 发送请求标记,1:表示发送   0：表示不发送
		if (!WebRTCRoomManager.isRoomFull(r)) {// 房间有两个人开始发送数据
			initiator = 0;// 如果房间不满人则不发送连接的请求
		}
		
		
		String roomLink = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/mobile/CommunicationController/CommunicationController_goMain?r=" + r;
		mv.addObject("initiator", initiator);
		mv.addObject("roomLink", roomLink);
		mv.addObject("room", r);
		mv.addObject("user", u);

		pd.put("wxName", session.getId());
		mv.addObject("info", pd);

		return mv;
	}

	/**
	 * 发送消息
	 * 
	 * @author lyq
	 * @date 2018年5月1日 20:25:24
	 * @param page
	 *            分页对象
	 */
	@RequestMapping(value = "/message")
	@ResponseBody
	public Object doVidio() throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		LiveWebSocketHandler websocket = new LiveWebSocketHandler();
		PageData connetpd = new PageData();

		String r = pd.getString("r");// 房间号
		String u = pd.getString("u");// 通话人
		if (r == null || u == null) {
			return pd;
		}
		BufferedReader br = request.getReader();
		String line = null;
		StringBuilder sb = new StringBuilder();
		while ((line = br.readLine()) != null) {
			sb.append(line); // 获取输入流，主要是视频定位的信息
		}
		String message = sb.toString();
		if (message.isEmpty()) {
			return pd;
		}

		JSONObject json = JSONObject.fromObject(message);
		String otherUser = "";
		try {
			otherUser = WebRTCRoomManager.getOtherUser(r, u);// 获取通话的对象
		} catch (NullPointerException  e) {
		}
		
		if (u.equals(otherUser)) {
			message = message.replace("\"offer\"", "\"answer\"");
			message = message.replace("a=crypto:0 AES_CM_128_HMAC_SHA1_32", "a=xrypto:0 AES_CM_128_HMAC_SHA1_32");
			message = message.replace("a=ice-options:google-ice\\r\\n", "");
		}

		pd.put("message", message);
		connetpd.put("u", otherUser);
		if (pd.get("message") != null) {
			connetpd.put("message", pd.get("message"));
		}

		if (json != null) {
			String type = json.getString("type");
			if ("bye".equals(type)) {// 客户端退出视频聊天
				System.out.println("user :" + u + " exit..");
				try {
					WebRTCRoomManager.removeUser(r, u);
				} catch (NullPointerException  e) {
				}
				
				if (connetpd.get("u") != null) {
					websocket.sendNewProductDatas(connetpd);// 推送到客户端
				}
				closeVedio(u );
				return pd;
			}
		}

		// 向对方发送连接数据
		if (connetpd.get("u") != null) {
			websocket.sendNewProductDatas(connetpd);// 推送到客户端
		}

		return pd;

	}

	/**
	 * 发送消息
	 * 
	 * @author lyq
	 * @date 2018年5月1日 20:25:24
	 * @param page
	 *            分页对象
	 */
	@RequestMapping(value = "/sendMsg")
	@ResponseBody
	public Object doEdit() throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			pd.put("id", this.get32UUID());
			pd.put("ImgUrl", "13");
			pd.put("wxName", session.getId());

			LiveWebSocketHandler websocket = new LiveWebSocketHandler();
			websocket.sendNewProductDatas(pd);// 推送到客户端

			pd.put("flag", true);
			pd.put("msg", "发送成功！");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.toString(), e);
			pd.put("flag", false);
			pd.put("msg", "发送失败！");
		}
		return pd;

	}
	
	
	/**
	 * 创建房间号
	 * 
	 * @author lyq
	 * @date 2018年7月9日 12:23:40
	 */
	@RequestMapping(value = "/CommunicationController_createRoom")
	@ResponseBody
	public Object createRoom() throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();

		String user = pd.get("u").toString();// 通话人
		String room = "";// 房间号
		if (pd.get("r") == null) {// 首次进来 新建房间
			room = this.get32UUID();
			pd.put("room", room);
		} else {// 带着房间号进来
			room = pd.get("r").toString();
		}
		
		WebRTCRoomManager.createRoom(room);// 创建房间    加入用户
		
		String roomLink = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/mobile/CommunicationController/CommunicationController_goMain.do";
		pd.put("roomLink", roomLink);
		pd.put("room", room);
		pd.put("user", user);
		pd.put("flag", true);
		
		response.setHeader("Access-Control-Allow-Origin", "*");
		return pd;
	}
	

	/**
	 * 视频结束
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public PageData closeVedio(String user) {
		InetAddress address;
		try {
			address = InetAddress.getLocalHost();//获取的是本地的IP地址 //LAPTOP-PI4K538J/172.16.51.185
			String hostAddress = address.getHostAddress();//获取本地IP地址：172.16.51.185
//			String url = "http://121.46.4.32:8071/OnlineConsultController/OnlineConsultController_updateDoctorStatus";//视频系统请求的路径
			String url = "http://192.168.1.177:8080/OnlineConsultController/OnlineConsultController_updateDoctorStatus";//视频系统请求的路径
			String params = "userId="+user+"&isBusy=N";
			String result = sendPost(url, params);// java 发送post请求视频系统 ,让视频系统创建房 间

			// json转Map
			Gson gson = new Gson();
			Map<String, Object> temp = new HashMap<String, Object>();
			temp = gson.fromJson(result, temp.getClass());
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		
		
		PageData pd =new PageData();
		return pd;
	}
	
	/**
     * 向指定 URL 发送POST方法的请求(http)
     * 
     * @param url
     *            发送请求的 URL
     * @param param
     *            请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
     */
    public String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }  
    
    /**
   	 * 呼叫通话   查看房间是否有两个人    
   	 * 
   	 * @author lyq
   	 * @date 2018年8月1日 09:24:36
   	 * @param page
   	 *            分页对象
   	 */
   	@RequestMapping(value = "/isConnectVideo")
   	@ResponseBody
   	public Object isConnectVideo() throws Exception {
   		PageData pd = new PageData();
   		pd = this.getPageData();
   		try {
   			if(WebRTCRoomManager.isRoomFull(pd.getString("room"))){
   				pd.put("flagVideo", true);
   				pd.put("msg", "视频连接成功！");
   			}else{
   				pd.put("flagVideo", false);
   				pd.put("msg", "无人应答...");
   			}
   			pd.put("flag", true);
   			
   			
   		} catch (Exception e) {
   			e.printStackTrace();
   			logger.error(e.toString(), e);
   			pd.put("flag", false);
   			pd.put("msg", "视频连接失败！");
   		}
   		return pd;

   	}

}
