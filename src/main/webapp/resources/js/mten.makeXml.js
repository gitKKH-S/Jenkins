HashMap = function(){
	this.map = new Array();
}

HashMap.prototype = {   
    put : function(key, value){   
        this.map[key] = value; 
    },   
    get : function(key){   
        return this.map[key]; 
    },   
    getAll : function(){   
        return this.map; 
    },   
    clear : function(){   
        this.map = new Array(); 
    },   
    isEmpty : function(){     
         return (this.map.size() == 0); 
    }, 
    remove : function(key){     
         delete this.map[key]; 
    }, 
    toString : function(){ 
        var temp = ''; 
        for(i in this.map){   
            temp = temp + ',' + i + ':' +  this.map[i]; 
        } 
        temp = temp.replace(',',''); 
          return temp; 
    }, 
    keySet : function(){   
        var keys = new Array();   
        for(i in this.map){   
            keys.push(i); 
        }   
        return keys; 
    } 
}; 

function makeXML(map){
	var strXML = "<data>";
	//sample="lawxml=메인,prtlaw=조선택출력,downlaw=cd제작"
	strXML = strXML + "<exeform>"+map.get("exeform")+"</exeform>";
	strXML = strXML + "<bookid>"+map.get("bookid")+"</bookid>";
	if (map.get("statehistoryid")) {
		strXML = strXML + "<statehistoryid>"+map.get("statehistoryid")+"</statehistoryid>";
	}
	if (map.get("before_statehistoryid")) {
		//^explanation=\"해당안될경우^0\"
		strXML = strXML + "<before_statehistoryid>"+map.get("before_statehistoryid")+"</before_statehistoryid>";
	}
	if (map.get("revmode")) {
	//^explanation=\"제정0,수정1,개정2,연속개정3,과거수정4\"
		strXML = strXML + "<revmode>"+map.get("revmode")+"</revmode>";
	}
	if(map.get("filecd")){
		strXML = strXML + "<filecd>"+map.get("filecd")+"</filecd>";
	}
	if(map.get("contids")){
		strXML = strXML + "<contids>"+map.get("contids")+"</contids>";
	}
	strXML = strXML + "<LKRMS5configurl>"+URLINFO+"/resources/edit/LKRMS5.config</LKRMS5configurl>";
	strXML = strXML + "<LawXmlconfigurl>"+URLINFO+"/resources/edit/LawXml.exe.config</LawXmlconfigurl>";
	strXML = strXML + "</data>";
	return strXML;
}

function makeDocXML(map){
	var strXML = "<data>";
	if(map.get("private")){
		strXML = strXML + "<private>"+map.get("private")+"</private>";
	}
	strXML = strXML + "<write>"+map.get("write")+"</write>";
	strXML = strXML + "<file>"+map.get("file")+"</file>";
	strXML = strXML + "<gianurl>"+map.get("gianurl")+"</gianurl>";
	strXML = strXML + "<saveurl>"+map.get("saveurl")+"</saveurl>";
	strXML = strXML + "<AutoReport>"+map.get("AutoReport")+"</AutoReport>";
	strXML = strXML + "<LKRMS5configurl>"+URLINFO+"/resources/edit/LKRMS5.config</LKRMS5configurl>";
	strXML = strXML + "<LawXmlconfigurl>"+URLINFO+"/resources/edit/LawXml.exe.config</LawXmlconfigurl>";
	strXML = strXML + "</data>";
	return strXML;
}

function makeDocFileXML(map){
	var strXML = "<data>";
	if(map.get("private")){
		strXML = strXML + "<private noshow='1'>"+map.get("private")+"</private>";
	}
	strXML = strXML + "<write>"+map.get("write")+"</write>";
	strXML = strXML + "<files>";
	strXML = strXML + map.get("file");
	strXML = strXML + "</files>";
	strXML = strXML + "<docgbn>"+map.get("docgbn")+"</docgbn>";
	strXML = strXML + "<gianurl>"+map.get("gianurl")+"</gianurl>";
	strXML = strXML + "<saveurl>"+map.get("saveurl")+"</saveurl>";
	strXML = strXML + "<AutoReport>"+map.get("AutoReport")+"</AutoReport>";
	strXML = strXML + "<LKRMS5configurl>"+URLINFO+"/resources/edit/LKRMS5.config</LKRMS5configurl>";
	strXML = strXML + "<LawXmlconfigurl>"+URLINFO+"/resources/edit/LawXml.exe.config</LawXmlconfigurl>";
	strXML = strXML + "</data>";
	return strXML;
}