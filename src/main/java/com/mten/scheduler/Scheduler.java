package com.mten.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.mten.bylaw.gian.service.GianService;
import com.mten.bylaw.mif.serviceSch.MifService;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;


@Component
public class Scheduler {
	@Resource(name="mifService")
	private MifService mifService;
	
	@Resource(name="gianService")
	private GianService gianService;
	
	//@Resource(name="lawifService")
	//public LawifService lawifService;
	
	//@Scheduled(cron = "0 15 23 ? * WED")//매주 수요일 11시15분
	@Scheduled(cron = "0/1 * * * * ?")//매초   (cron = "0 15 23 ? * WED")
	public void cron1(){
		try {
			//System.out.println("DDD2");
			//mifService.setInsertLaw();
		} catch (Exception e) {
			System.out.println("DDD3");
			e.printStackTrace();
		}
	}

	//fixedDelay은 이전에 실행된 Task의 종료시간으로 부터 정의된 시간만큼 지난 후 Task를 실행한다.(밀리세컨드 단위)
	//fixedRate은 이전에 실행된 Task의 시작시간으로 부터 정의된 시간만큼 지난 후 Task를 실행한다.(밀리세컨드 단위)
	//@Scheduled(cron = "${schedule.time1h}")//매일새벽2시
	@Scheduled(cron = "0 15 4 * * *")
	public void cron2(){
		try {
			System.out.println("대법원 크롤링 시작");
			//method 1
	        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	        System.out.println(timestamp);
            
	        //method 2 - via Date
	        Date date = new Date();
	        System.out.println(new Timestamp(date.getTime()));
	        
	        //mifService.updateSuitDate();
	        
	        //return number of milliseconds since January 1, 1970, 00:00:00 GMT
	        System.out.println(timestamp.getTime());
            
	        //format timestamp
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
            
	        System.out.println(sdf.format(timestamp));
	        System.out.println("대법원 크롤링 종료");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//@Scheduled(cron = "${schedule.time1h}")//매일새벽2시
	@Scheduled(cron = "0 15 5 * * *")
	public void cron2_1(){
		try {
			/*System.out.println("부서정보 업데이트시작");
			//method 1
	        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	        System.out.println(timestamp);
            
	        //method 2 - via Date
	        Date date = new Date();
	        System.out.println(new Timestamp(date.getTime()));
            
	        mifService.setInsaInfo();
	        
	        //return number of milliseconds since January 1, 1970, 00:00:00 GMT
	        System.out.println(timestamp.getTime());
            
	        //format timestamp
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
            
	        System.out.println(sdf.format(timestamp));
	        System.out.println("부서정보 업데이트종료");*/
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//@Scheduled(cron = "${schedule.time1h}")//매일새벽2시
	@Scheduled(cron = "0 00 8 * * *") // 매일 아침 8시
	public void cron2_2(){
		try {
			System.out.println("송무기일정보 문자알림 시작");
			//method 1
	        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	        System.out.println(timestamp);
            
	        //method 2 - via Date
	        Date date = new Date();
	        System.out.println(new Timestamp(date.getTime()));
            
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String getDate = sdf.format(timestamp);
	        mifService.noticeSms(getDate);
	        
	        //return number of milliseconds since January 1, 1970, 00:00:00 GMT
	        System.out.println(timestamp.getTime());
            
	        //format timestamp
	        sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
            
	        System.out.println(sdf.format(timestamp));
	        System.out.println("송무기일정보 문자알림 종료");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//@Scheduled(cron = "${schedule.time1h}")//매일새벽2시
	@Scheduled(cron = "0 10 1 * * *")
	public void cron2_3(){
		try {
			System.out.println("송무기일정보 메일알림 시작");
			//method 1
	        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	        System.out.println(timestamp);
            
	        //method 2 - via Date
	        Date date = new Date();
	        System.out.println(new Timestamp(date.getTime()));
	        SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD");
	        String getDate = sdf.format(timestamp);
	        mifService.noticeMail(getDate);
	        
	        //return number of milliseconds since January 1, 1970, 00:00:00 GMT
	        System.out.println(timestamp.getTime());
            
	        //format timestamp
	        sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
            
	        System.out.println(sdf.format(timestamp));
	        System.out.println("송무기일정보 메일알림 종료");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	//@Scheduled(cron = "${schedule.time1h}")//매일새벽2시
	@Scheduled(cron = "0 30 8 * * *") // 매일 아침 8시 30분
	public void cron2_4(){
		try {
			System.out.println("법인임기만료 메일 알림 시작");
			//method 1
	        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	        System.out.println(timestamp);
            
	        //method 2 - via Date
	        Date date = new Date();
	        System.out.println(new Timestamp(date.getTime()));
            
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String getDate = sdf.format(timestamp);
	        mifService.noticeLawyerInfo(getDate);
	        
	        //return number of milliseconds since January 1, 1970, 00:00:00 GMT
	        System.out.println(timestamp.getTime());
            
	        //format timestamp
	        sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
            
	        System.out.println(sdf.format(timestamp));
	        System.out.println("법인임기만료 메일 알림 종료");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Scheduled(fixedDelay=60000)
	public void cron3(){
		try {
			System.out.println("온나라스케쥴");
	        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	        System.out.println(timestamp);
	        Date date = new Date();
	        System.out.println(new Timestamp(date.getTime()));
            
	        System.out.println(timestamp.getTime());
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
	        System.out.println(sdf.format(timestamp));
            
	        gianService.gianAllUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
