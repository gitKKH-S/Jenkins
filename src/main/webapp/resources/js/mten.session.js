var Grpcd = '';
var Grpcd2 = '';
var stateCd = '';
var Orgname = '';
var Deptcd = '';
var suserid = '';
var susername = '';
var team = '';

var IPADDR = '';
var ISDEVICE = '';

const iterationCount = 1000;
const keySize = 128 / 32;
var hkksize;
// Generate encryption key
function generateKey(salt, passPhrase) {
  return CryptoJS.PBKDF2(passPhrase, CryptoJS.enc.Hex.parse(salt), {
    keySize: keySize,
    iterations: iterationCount
  });
}
// Encrypt text
function encrypt(salt, iv, plainText) {
  //const passPhrase = process.env.REACT_APP_ENCRYPT_SECRET;
  //const key = generateKey(salt, passPhrase);
  const encrypted = CryptoJS.AES.encrypt(plainText, CryptoJS.enc.Utf8.parse(hkksize), {
    iv: CryptoJS.enc.Hex.parse(iv),
    mode: CryptoJS.mode.CTR,
    padding: CryptoJS.pad.NoPadding
  });
  return encrypted.ciphertext.toString(CryptoJS.enc.Base64);
}
// Decrypt text
function decrypt(salt, iv, cipherText) {
  //const passPhrase = process.env.REACT_APP_DECRYPT_SECRET;
  //const key = generateKey(salt, passPhrase);
  const decrypted = CryptoJS.AES.decrypt({
    ciphertext: CryptoJS.enc.Base64.parse(cipherText)
  }, CryptoJS.enc.Utf8.parse(hkksize), {
    iv: CryptoJS.enc.Hex.parse(iv),
    mode: CryptoJS.mode.CTR,
    padding: CryptoJS.pad.NoPadding
  });
  return decrypted.toString(CryptoJS.enc.Utf8);
}
$.ajax({
	type:'post',
	url:CONTEXTPATH+'/login/getSession.do',
	dataType: "json",
	async: false,
	success:function(data){
		console.log(data.message.code);
		
		// Example usage
		const salt = data.data.hkk2;//'a1b2c3d4';
		const iv = data.data.hkk3;//'1234567890abcdef1234567890abcdef';
		hkksize = data.data.hkk1;
		//const text = 'Sensitive Data';
		//const encryptedText = encrypt(salt, iv, text);
		//console.log('Encrypted:', encryptedText);
		const decryptedText = decrypt(salt, iv, data.data.en);
		//console.log('Decrypted:', decryptedText);
		
		var jdata = JSON.parse(decryptedText);
		
		//alert(jdata);
		
		if(jdata.GRPCD){
			console.log("mten.session.js ==");
			console.log(jdata);
			console.log("mten.session.js ==");
			Grpcd = jdata.GRPCD;
			stateCd = '';
			Orgname = jdata.DEPTNAME;
			Deptcd = jdata.DEPTCD;
			suserid = jdata.USERID;
			susername = jdata.USERNAME;
			team = jdata.TEAM;
			IPADDR = jdata.IPADDR;
			ISDEVICE = jdata.ISDEVICE;
			
			//if(!(Grpcd.indexOf("Y")>-1||Grpcd.indexOf("A")>-1||Grpcd.indexOf("G")>-1||Grpcd.indexOf("B")>-1
			//		||Grpcd.indexOf("H")>-1||Grpcd.indexOf("R")>-1||Grpcd.indexOf("T")>-1||Grpcd.indexOf("J")>-1||Grpcd.indexOf("C")>-1||jdata.TEAM > 0)
			//){
			//	alert("접근 권한이 없습니다.");
			//}
			if(Grpcd.indexOf("Y")>-1 || Grpcd.indexOf("G")>-1){
				Grpcd2="S";
			}else if(Grpcd.indexOf("C")>-1 || Grpcd.indexOf("L")>-1||
				Grpcd.indexOf("J")>-1 || Grpcd.indexOf("M")>-1 || Grpcd.indexOf("A")>-1 ||
				Grpcd.indexOf("N")>-1 || Grpcd.indexOf("B")>-1 || Grpcd.indexOf("D")>-1 ||
				Grpcd.indexOf("E")>-1 || Grpcd.indexOf("F")>-1 ||
				Grpcd.indexOf("I")>-1 || Grpcd.indexOf("Q")>-1 || Grpcd.indexOf("R")>-1
					) {
				//else if(Grpcd.indexOf("J")>-1 || Grpcd.indexOf("C")>-1){
				Grpcd2="T";
			}
		}else{
			alert("사용자 정보가 존재 하지 않습니다.");
			top.location.href=CONTEXTPATH+"/index.do"
		}
	},
	error:function(e){
		alert("사용자 정보가 존재 하지 않습니다.");
	}
})
