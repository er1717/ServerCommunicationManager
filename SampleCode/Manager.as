

///////////////////////////////////////////////////
///  Author: Emerson Rascoe
///  Communication Component
///  Manager Class
////////////////////////////////////////////////////

package com.communication
{
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import flash.net.URLLoader;
		
	public class Manager
	{
		private var _requestArray:Array = new Array();
		private var _tokenArray:Array = new Array();
		
		
		public function Manager()
		{
			
		}
		
		
		/**
		 * Calls all necessary functions to start this class 
		 * 
		 */		
		private function init():void
		{
			//null for now
		}
		
		
	    /**
	     * Adds the token to the token Array if the token isnt null 
	     * @param inToken
	     * 
	     */		
	    public function registerCommunicationRequestObjects(inObject:Object):void
	    {
	    	inObject != null ? this._requestArray.push(inObject):null;
	    }
	    
	    
	    /**
	     *Retunrs the Array of Communication Request Objects 
	     * @return 
	     * 
	     */	   
	    public function get theCommunicationRequestObjects():Array
	    {
	    	return this._requestArray;
	    }
	    
	    
	    /**
	     * Finds the correspondingCommunication Request Object Based upon a token passed as an argument
	     * and returns that Corresponding Object 
	     * @param inToken
	     * @return 
	     * 
	     */	    
	    public function findRequestObjectByToken(inToken:AsyncToken):Object
	    {
	        var tempObject:Object;
	    	for(var i:int = 0; i< this._requestArray.length;i++)
	    	{
	    		if(this._requestArray[i]._token == inToken)
	    		{
	    			tempObject = this._requestArray[i];
	    			i = this._requestArray.length;
	    		}
	    		else
	    		{
	    			//can have logic to handle intoken isnt matched
	    		}
	    	}
	    	return tempObject;
	    }
	    
	   
	   
	   /**
	     * Finds the correspondingCommunication Request Object Based upon a loader passed as an argument
	     * and returns that Corresponding Object 
	     * @param inLoader
	     * @return 
	     * 
	     */	    
	    public function findRequestObjectByLoader(inLoader:URLLoader = null):Object
	    {
	        var tempObject:Object;
	    	for(var i:int = 0; i< this._requestArray.length;i++)
	    	{
	    		if(this._requestArray[i]._loader == inLoader)
	    		{
	    			tempObject = this._requestArray[i];
	    			i = this._requestArray.length;
	    		}
	    		else
	    		{
	    			//can have logic to handle intoken isnt matched
	    		}
	    	}
	    	return tempObject;
	    }
	    
	    
	    /**
	     * Removes the object passed as an object from the Communication Request Array
	     * @param inObject
	     * 
	     */	    
	    public function removeRequestObject(originalObject:Object, returnObject:Object=null):void
	    { 
			originalObject ? this._requestArray.splice(this._requestArray.indexOf(originalObject),1)[0].callback(returnObject, originalObject):null;
	    }
	   
	}
}