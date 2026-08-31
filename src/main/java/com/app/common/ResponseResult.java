package com.app.common;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ResponseResult<T> {
	
	private Boolean success;
	private String message;
	private T data;
	public static <T> ResponseResult<T> success(T data){
		ResponseResult<T> responseResult = new ResponseResult<T>(); 
		
		responseResult.success = true;
		responseResult.message = "성공";
		responseResult.setData(data);
		
		return responseResult;
	}
}
