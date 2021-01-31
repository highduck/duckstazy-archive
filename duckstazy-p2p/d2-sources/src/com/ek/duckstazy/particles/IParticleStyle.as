package com.ek.duckstazy.particles
{
	/**
	 * @author Elias Ku
	 */
	public interface IParticleStyle
	{
		function createParticle():IParticle;
		function getName():String;
		function parseXML(xml:XML):void
	}
}
