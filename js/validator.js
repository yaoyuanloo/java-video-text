/**
 * @auther lsj
 * 拓展的校验器
 */
$.extend($.fn.validatebox.defaults.rules, {  
    //移动手机号码验证  
    mobile: {//value值为文本框中的值  
        validator: function (value) {  
        	var re = /^((\d{11})|^((\(\d{3}\))|(\d{3}\-))?((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)$/;;  
            return re.test(value);  
        },  
        message: '输入手机号码格式不准确.'  
    },  
    //国内邮编验证  
    zipcode: {  
        validator: function (value) {  
            var reg = /^[1-9]\d{5}$/;  
            return reg.test(value);  
        },  
        message: '邮编必须是非0开始的6位数字.'  
    },
    email:{
    	validator:function(value){
    		  var reg=/(^\s*)\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\s*$)/;
    		  return reg.test(value);
    	},
    	message:'邮箱格式不正确'
    },
    number:{
    	validator:function(value){
    		 var re = /(^-?[1-9]\d*$)|^0$/;
    		  return re.test(value);
    	},
    	message:'请输入整数'
     },
     idCard:{
    	validator:function(value){
    		var reg=/^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/;
    		return reg.test(value);
    	},
    	message:'请输入合法的身份证号码'	 
     }
    
    
    
    
    
    	    
    
})