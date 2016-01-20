/**
 * Class used in the building custom setting for use in test methods.
 * creates either an AgentStatsScoringLevel__c custom setting or 
 * an AgentStatsScoringLevels_EmailAndCalls__c custom setting
 *
 * @author Mike McGee
 */
@isTest
public with sharing class AgentStatCustSetBuilder {
	
	/** name of the custom setting */
	private String name; 
	
	/** value at which good level starts */
	private double goodLevel; 
	
	/** Number of points at good level */
	private double goodPoints; 
	
	/** Value at which needs improvement level starts */
	private double niLevel; 
	
	/** Number of points at needs improvement level */
	private double niPoints;
	
	/** Value at which oustanding level starts */ 
	private double outLevel;
	
	/** Number of points at outstanding level */ 
	private double outPoints;
	
	/** Value at which superior level starts */
	private double supLevel;
	
	/** Number of points at superior level */ 
	private double supPoints;
	
	/** Number of points at unsatisfactory level */
	private double unsatPoints; 
	
	/** The ranking style that should be used */
	private String RankStyle; 
	
	
	/** 
	 * Creates builder and sets name 
	 * @param custom setting name
	 */
	public AgentStatCustSetBuilder(String name) {
		this.name = name; 
	}


	/**
	 * Creates builder and sets all values needed. 
	 * 
	 * @param name of custom setting
	 * @param good level value
	 * @param good point value
	 * @param needs improvement level value
	 * @param needs improvement point value
	 * @param outstanding level value
	 * @param outstanding point value
	 * @param superior level value
	 * @param superior point value
	 * @param unsatisfactory point value
	 * @param ranking style
	 */
	 public AgentStatCustSetBuilder(String name, Double goodLevel, Double goodPoints,
	 		Double niLevel, Double niPoints, Double outLevel, Double outPoints, 
	 		Double supLevel, Double supPoints, Double unsatPoints, String rankStyle) {
	 	this.name = name; 
	 	this.goodLevel = goodLevel; 
	 	this.goodPoints = goodPoints;
	 	this.niLevel = niLevel; 
	 	this.niPoints = niPoints; 
	 	this.outLevel = outLevel; 
	 	this.outPoints = outPoints; 
	 	this.supLevel = supLevel; 
	 	this.supPoints = supPoints; 
	 	this.unsatPoints = unsatPoints; 
	 	this.rankStyle = rankStyle;
	 }
	
	
	/**
	 * Builds AgentStatsScoringLevel__c custom setting
	 * @return the custom setting
	 */
	 public AgentStatsScoringLevel__c buildNonEmailSetting() {
	 	AgentStatsScoringLevel__c custSetting = new AgentStatsScoringLevel__c();
	 	
	 	custSetting.Name = this.name; 
	 	custSetting.GoodLevel__c = this.goodLevel; 
	 	custSetting.GoodPoints__c = this.goodPoints;
	 	custSetting.NeedsImprovementLevel__c = this.niLevel; 
	 	custSetting.NeedsImprovementPoints__c = this.niPoints;
	 	custSetting.OutstandingLevel__c = this.outLevel; 
	 	custSetting.OutstandingPoints__c = this.outPoints; 
	 	custSetting.SuperiorLevel__c = this.supLevel; 
	 	custSetting.SuperiorPoints__c = this.supPoints; 
	 	custSetting.UnsatisfactoryPoints__c = this.unsatPoints; 
	 	custSetting.RankStyle__c = this.rankStyle; 
	 	
	 	return custSetting; 
	 }
	 
	 
	 /**
	 * Builds AgentStatsScoringLevels_EmailAndCalls__c custom setting
	 * @return the custom setting
	 */
	 public AgentStatsScoringLevels_EmailAndCalls__c buildEmailSetting() {
	 	AgentStatsScoringLevels_EmailAndCalls__c custSetting = 
	 							new AgentStatsScoringLevels_EmailAndCalls__c();
	 	custSetting.Name = this.name; 
	 	custSetting.GoodLevel__c = this.goodLevel; 
	 	custSetting.GoodPoints__c = this.goodPoints;
	 	custSetting.NeedsImprovementLevel__c = this.niLevel; 
	 	custSetting.NeedsImprovementPoints__c = this.niPoints;
	 	custSetting.OutstandingLevel__c = this.outLevel; 
	 	custSetting.OutstandingPoints__c = this.outPoints; 
	 	custSetting.SuperiorLevel__c = this.supLevel; 
	 	custSetting.SuperiorPoints__c = this.supPoints; 
	 	custSetting.UnsatisfactoryPoints__c = this.unsatPoints; 
	 	custSetting.RankStyle__c = this.rankStyle; 
	 	
	 	return custSetting;
	 }
	
	
	/** 
	 * sets good level 
	 * @param good level value
	 */
	public void setGoodLevel(Double value) {
		this.goodLevel = value;
	}
	
	
	/** 
	 * sets good points 
	 * @param good points value
	 */
	public void setGoodPoints(Double value) {
		this.goodPoints = value; 
	}
	
	
	/** 
	 * sets niLevel 
	 * @param needs improvement value 
	 */
	public void setNiLevel(Double value) {
		this.niLevel = value; 
	}
	
	/** 
	 * sets niPoints 
	 * @param needs improvement points value
	 */
	public void setNiPoints(Double value) {
		this.niPoints = value; 
	}
	
	
	/**
	 * sets outstanding level
	 * @param outstanding level value
	 */
	public void setOutLevel(Double value) {
		this.outLevel = value; 
	}
	
	
	/**
	 * sets outstanding level points
	 * @param outstandning point value
	 */
	public void setOutPoints(Double value) {
		this.outPoints = value;
	}
	
	
	/**
	 * sets superior level
	 * @param superior level value
	 */
	public void setSupLevel(Double value) {
		this.supLevel = value; 
	}
	
	
	/**
	 * sets superior point value
	 * @param superior point value
	 */
	public void setSupPoints(Double value) {
		this.supPoints = value; 
	}
	
	
	/**
	 * sets unsatisfactory point value
	 * @param unsatisfactory point value
	 */
	public void setUnsatPoints(Double value) {
		this.unsatPoints = value; 
	}
	
	
	
	/**
	 * sets the rank style
	 * @param the style for ranking
	 */
	public void setRankStyle(String style) {
		this.rankStyle = style; 
	}
	
}