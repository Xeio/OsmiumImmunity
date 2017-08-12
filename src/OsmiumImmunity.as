import com.GameInterface.DistributedValue;
import com.GameInterface.InventoryItem;
import com.GameInterface.ShopInterface;
import flash.geom.Point;
import mx.utils.Delegate;
import com.Utils.Archive;

import com.GameInterface.Game.CharacterBase;
import com.GameInterface.Inventory;
import com.GameInterface.GroupFinder;
import com.GameInterface.Playfield;
import com.GameInterface.Game.Character;
import com.GameInterface.Game.BuffData;
import com.GameInterface.Spell;

class OsmiumImmunity
{    
	static var OSMIUM_NAME:String = "The Osmium Configuration";
	static var OSMIUM_ID_RED:Number = 9277010;
	static var OSMIUM_ID_GREEN:Number = 9270564;
	
	private var m_swfRoot: MovieClip;
	
	private var m_character:Character;
		
	public static function main(swfRoot:MovieClip):Void 
	{
		var osmiumImmunity = new OsmiumImmunity(swfRoot);
		
		swfRoot.onLoad = function() { osmiumImmunity.OnLoad(); };
		swfRoot.OnUnload =  function() { osmiumImmunity.OnUnload(); };
		swfRoot.OnModuleActivated = function(config:Archive) { osmiumImmunity.Activate(config); };
		swfRoot.OnModuleDeactivated = function() { return osmiumImmunity.Deactivate(); };
	}
	
    public function OsmiumImmunity(swfRoot: MovieClip) 
    {
		m_swfRoot = swfRoot;
    }
	
	public function OnLoad()
	{
		m_character = Character.GetCharacter(CharacterBase.GetClientCharID());
		m_character.SignalBuffAdded.Connect(BuffAdded, this);
	}
	
	public function OnUnload()
	{
		m_character.SignalBuffAdded.Disconnect(BuffAdded, this);
		m_character = undefined;
	}
	
	public function Activate(config: Archive)
	{
	}
	
	public function Deactivate(): Archive
	{
		var archive: Archive = new Archive();			
		return archive;
	}
	
	function BuffAdded(buffID:Number)
	{
		var buff:BuffData = m_character.m_BuffList[buffID];
		if (buff != undefined)
		{
			if (buff.m_Name == OSMIUM_NAME || buff.m_BuffId == OSMIUM_ID_GREEN || buff.m_BuffId == OSMIUM_ID_RED)
			{
				if (m_character.GetID().GetInstance() != buff.m_CasterId)
				{
					Spell.CancelBuff(buff.m_BuffId, buff.m_CasterId);
				}
			}
		}
	}
}