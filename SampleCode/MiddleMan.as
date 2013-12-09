
///////////////////////////////////////////////////
///  Author: Emerson Rascoe
///  Communication Component
///  MiddleMan Class
////////////////////////////////////////////////////
package com.communication
{
	import com.communication.Communicator;
	import com.communication.Manager;
	import com.communication.Verifier;

	public class MiddleMan
	{
		private static var _instance:MiddleMan;
		private var _manager:Manager;
		private var _verifier:Verifier;
		private var _communicator:Communicator;
		public var _broker:Object;


		
		public function MiddleMan(inSingletonEnforcer:SingletonEnforcer)
		{
			inBroker ? this._broker = inBroker:null;
			this.init();
		}
		
		
		/**
		 * Singleton Pattern Returns this instance of this class
		 * @return 
		 * 
		 */
		public static function getInstance():MiddleMan
		{
			if (_instance == null) 
			{
				 _instance = new MiddleMan(new SingletonEnforcer()); 
			}
			return _instance;
		}
		
		
		
		/**
		 *Calls necessary methods to build this object 
		 * 
		 */		
		private function init():void
		{
			_instance = this;
			this._manager = new Manager();
			this._communicator = new Communicator(this);
			this._verifier = new Verifier(this);
		}
		
		
		/**
		 * Called for a simple authentication verification this 
		 * is used by the Common Uploader prior to the actual uploading process 
		 * @param inObject
		 * 
		 */		
		public function authenticateSession(inObject:Object):void
		{
			this._verifier.verify(inObject);
		}
		
		
		/**
		 *Does not attempt to authenticate, simply logs the user back into the session 
		 * @param inObject
		 * 
		 */		
		public function doLogin(inObject:Object):void
		{
			this._communicator.loginRequest(inObject);
		}
		
		
		/**
		 * 
		 * @param inObject
		 * 
		 */		
		public function handleHessianObject(inObject:Object):void
		{
			this._verifier.verify(inObject);
		}
		
		

		
		/**
		 * Returns reference of the Manager class 
		 * @return 
		 * 
		 */		
 
		public function get theManager():Manager
		{
			return this._manager;
		}

		
		/**
		 *Returns refeference of the Communicator class 
		 * @return 
		 * 
		 */	
	
		public function get theCommunicator():Communicator
		{
			return this._communicator;
		}
		
		
		/**
		 *Returns a reference of the Broker 
		 * @return 
		 * 
		 */	
		 	
		public function get theBroker():Object
		{
			return this._broker;
		}
		
		
		/**
		 *Sets the broker 
		 * @param inBroker
		 * 
		 */		
		public function set broker(inBroker:Object):void
		{
			inBroker ? this._broker = inBroker:null;
		}
		
	}
}

internal class SingletonEnforcer{}