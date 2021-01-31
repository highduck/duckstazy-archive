package com.ek.duckstazy.particles
{

	/**
	 * @author Elias Ku
	 */
	public class ParticleShowFactory implements IParticleStyleFactory
	{
		public function createStyle(name:String, type:String):IParticleStyle
		{
			switch(type) {
				case "simple":
					return new ParticleStyle(name);
			}
			
			return null;
		}
	}
}
