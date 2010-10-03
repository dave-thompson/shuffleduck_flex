package com.shuffleduck.utils
{
	/**
	 * 	Performs utility WebService functions
	 * 
	 */
	
	import flash.utils.*;
	import com.adobe.crypto.MD5;
	
	public class WebServiceUtils // abstract - should never be instantiated; exists for utils only
	{
		public function WebServiceUtils()
		{
			// don't allow instantiation of this class
			throw new Error("WebServiceUtils is a utility class and can not be instantiated.");
		}

		// Supplies the parameters (always api_key and signature) to be used for web service requests
		// Takes the POST data as an input, and defaults to a GET request if that POST data is not given
		public static function buildRequestParamameters(postData:String = ""):String
		{
			// note that the current API implementation is susceptible to replay attack - this is especially significant due to the REST implementation not using parameters for its GET requests - any GET request may therefore be issued by an attacker using the same api_key and signature
			// enhanced security would require a timestamp to be sent along with the message & checked as being larger than previous timestamps

			var stringToHash:String;

			if (postData == "") // if a GET request, hash the key and secret
			{
				stringToHash = "app_key" + ShuffleDuck.APP_KEY + ShuffleDuck.APP_SECRET;
			}
			else // if a POST, hash the post data
			{
				stringToHash = postData + ShuffleDuck.APP_SECRET;
			}

			var signature:String = MD5.hash(stringToHash);
			var parameters:String = "?app_key=3000&signature=" + signature;						
			return parameters;
		}

	}
}

