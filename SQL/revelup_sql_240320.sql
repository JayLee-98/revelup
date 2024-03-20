DROP TABLE IF EXISTS `USER`;   -- 회원
DROP TABLE IF EXISTS `STTR_INFO`;   -- 세터 정보
DROP TABLE IF EXISTS `STTR_INFO_FILE`;   -- 세터 정보 파일
DROP TABLE IF EXISTS `FND_INFO`;   -- 펀딩 정보
DROP TABLE IF EXISTS `PLG`;   -- 후원
DROP TABLE IF EXISTS `WISHLIST`;   -- 찜한 펀딩
DROP TABLE IF EXISTS `DELIV`;   -- 배송
DROP TABLE IF EXISTS `RCPI`;   -- 수취인
DROP TABLE IF EXISTS `FND_INSERT_FILE`;   -- 펀딩 등록 파일
DROP TABLE IF EXISTS `GIFT`;   -- 선물
DROP TABLE IF EXISTS `STLMT_LIST`;   -- 정산 내역
DROP TABLE IF EXISTS `RPT`;   -- 신고
DROP TABLE IF EXISTS `NTC`;   -- 공지
DROP TABLE IF EXISTS `AUD`;   -- 심사
DROP TABLE IF EXISTS `AUD_DEC`;   -- 심사 반려
DROP TABLE IF EXISTS `INQ`;   -- 문의
DROP TABLE IF EXISTS `INQ_FILE`;   -- 문의 정보 파일


-- 회원
CREATE TABLE `USER`
(   `USER_ID`    VARCHAR(15) NOT NULL COMMENT '아이디',
		`USER_NAME`    VARCHAR(51) NOT NULL COMMENT '이름',
    `USER_PW`    VARCHAR(60) NOT NULL COMMENT '비밀번호',
		`USER_PHONE`    VARCHAR(13) NOT NULL COMMENT '전화번호',
		`USER_ADD`    VARCHAR(255) NOT NULL COMMENT '주소',
		`USER_EMAIL`    VARCHAR(100) NOT NULL COMMENT '이메일',
		`USER_ROLE`    VARCHAR(10) DEFAULT '게터' NOT NULL COMMENT '회원 권한',
		`USER_WDDT`    DATETIME NULL COMMENT '회원 탈퇴 일시',
 PRIMARY KEY ( `USER_ID` )
)COMMENT = '회원';


-- 세터 정보
CREATE TABLE `STTR_INFO`
(   `USER_ID`    VARCHAR(15) NOT NULL COMMENT '아이디',
    `STTR_COMPANY`    VARCHAR(255) NOT NULL COMMENT '법인명',
    `STTR_NAME`    VARCHAR(255) NOT NULL COMMENT '대표자명',
    `STTR_REGIST_NO`    LONG NOT NULL COMMENT '사업자 등록 번호',
    `STTR_BANK`    VARCHAR(50) NOT NULL COMMENT '은행',
    `STTR_ACC_NO`    VARCHAR(20) NOT NULL COMMENT '계좌번호',
    `STTR_ACC_HOLDER`    VARCHAR(25) NOT NULL COMMENT '예금주',
 PRIMARY KEY ( `USER_ID` ),
 FOREIGN KEY (`USER_ID`) REFERENCES USER (`USER_ID`)
)COMMENT = '세터 정보';


-- 세터 정보 파일
CREATE TABLE `STTR_INFO_FILE`
(   `SI_FILE_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '파일 코드',
		`USER_ID`         VARCHAR(15) NOT NULL COMMENT '아이디',
		`SI_FILE_LOC`     VARCHAR(255) NOT NULL COMMENT '파일 저장 경로',
    `SI_ORG_FILE`     VARCHAR(255) NOT NULL COMMENT '기존 파일명',
    `SI_SAVE_FILE`    VARCHAR(36) NOT NULL COMMENT '저장 파일명',
    `SI_FILE_DIV`    VARCHAR(1) NOT NULL COMMENT '파일 구분',
    `FILE_ATTACHED`    INT COMMENT '파일 첨부 유무',
 PRIMARY KEY ( `SI_FILE_CODE` ),
 FOREIGN KEY (`USER_ID`) REFERENCES STTR_INFO (`USER_ID`)
)COMMENT = '세터 정보 파일';

-- 펀딩 정보
CREATE TABLE `FND_INFO`
(   `FND_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '펀딩 코드',
    `USER_ID`    VARCHAR(15) NOT NULL COMMENT '아이디',
    `FND_NAME`    VARCHAR(255) NOT NULL COMMENT '펀딩명',
	  `FND_END_DT`    DATE NOT NULL COMMENT '펀딩 종료 일자',
	  `GOAL_AMT`    INT NOT NULL COMMENT '목표 금액',
	  `FND_DESCR`    VARCHAR(1500) NOT NULL COMMENT '펀딩 스토리',
	  `SUCCESS_AMT`    INT NOT NULL COMMENT '달성액',
		`FND_DEL_YN`    VARCHAR(1) DEFAULT 'N' NOT NULL COMMENT '펀딩 삭제 여부',
	  `FND_PRG_STAT`    VARCHAR(1) NOT NULL COMMENT '펀딩 진행 상태',
	  -- 후원내역(종료 + 진행) (L-FND_STAT), 후원철회(C-FND_STAT), 미달성펀딩(U-FND_STAT)
     `FILE_ATTACHED`    INT COMMENT '파일 첨부 유무',
     `FND_INSERT_DTTM`   DATETIME DEFAULT NOW() COMMENT '펀딩 심사 등록 일시',
 PRIMARY KEY ( `FND_CODE` ),
 FOREIGN KEY (`USER_ID`) REFERENCES STTR_INFO (`USER_ID`)
)COMMENT = '펀딩 정보';

-- 펀딩 등록 파일
CREATE TABLE `FND_INSERT_FILE`
(   `FILE_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '파일 코드',
    `FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
    `FND_FILE_LOC`    VARCHAR(255) NOT NULL COMMENT '파일 저장 경로',
    `FND_ORG_FILE`    VARCHAR(255) NOT NULL COMMENT '기존 파일명',
		`FND_SAVE_FILE`    VARCHAR(36) NOT NULL COMMENT '저장 파일명',
	  `FILE_DIV`    VARCHAR(1) NOT NULL COMMENT '파일 구분',
	  `FILE_ATTACHED`    INT COMMENT '파일 첨부 유무',
 PRIMARY KEY ( `FILE_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`)
)COMMENT = '펀딩 등록 파일';


-- 심사
CREATE TABLE `AUD`
(   `FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
	`FND_INSERT_DTTM`   DATETIME NOT NULL COMMENT '펀딩 심사 등록 일시', -- DATETIME DEFAULT NOW(),
    `AUDIT_STAT`    VARCHAR(10) DEFAULT 'P' NOT NULL COMMENT '심사 상태',  -- 심사승인,심사대기, 심사반려
	`AUDIT_APPR_DT`   DATE COMMENT '심사 처리 일자',
 PRIMARY KEY ( `FND_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`)
)COMMENT = '심사';


-- 심사 반려 
CREATE TABLE `AUD_DEC`
(   `FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
		`DEC_EMAIL`   VARCHAR(100) NOT NULL COMMENT '반려 대상 이메일',
    `DEC_REASON`    VARCHAR(1000) NOT NULL COMMENT '반려 사유',
 PRIMARY KEY ( `FND_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES AUD (`FND_CODE`)
)COMMENT = '심사 반려';


-- 선물
CREATE TABLE `GIFT`
(   `FND_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '펀딩 코드',
    `GIFT_PRICE`    INT NOT NULL COMMENT '선물 금액',
    `GIFT_NAME`    VARCHAR(100) NOT NULL COMMENT '선물명',
		`GIFT_PROD_QTY`    INT NOT NULL COMMENT '선물 생산 가능 수량',
 PRIMARY KEY ( `FND_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`)
)COMMENT = '선물';


-- 정산 내역
CREATE TABLE `STLMT_LIST`
(   `FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
    `STLMT_AMT`    INT NOT NULL COMMENT '정산 금액',
    `STLMT_SO_DTTM`    DATETIME  COMMENT '정산 완료 일시',
 PRIMARY KEY ( `FND_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`)
)COMMENT = '정산 내역';


-- 후원  --  FOREIGH 키 2개 일때 아래처럼 적는 것 맞는지 확인 필요
CREATE TABLE `PLG`
(   `PLG_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '후원 코드',
    `USER_ID`    VARCHAR(15) NOT NULL COMMENT '아이디',
    `FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
    `GIFT_QTY`    INT NOT NULL COMMENT '선물 수량',
    `PLG_DTTM`    DATETIME NOT NULL COMMENT '후원 일시',
    `PLG_PRICE`    INT NOT NULL COMMENT '후원 금액',
    `PLG_CAN_DT`    DATE COMMENT '후원 취소 일자',
 PRIMARY KEY ( `PLG_CODE` ),
 FOREIGN KEY (`USER_ID`) REFERENCES USER (`USER_ID`),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`)
)COMMENT = '후원';


-- 배송
CREATE TABLE `DELIV`
(   `PLG_CODE`    INT  NOT NULL COMMENT '후원 코드',
    `DELIV_STAT`    VARCHAR(1) DEFAULT 'R' NOT NULL COMMENT '배송 상태',
    `TRACKING_NO`    VARCHAR(13) COMMENT '운송장 번호',
 PRIMARY KEY ( `PLG_CODE` ),
 FOREIGN KEY (`PLG_CODE`) REFERENCES PLG (`PLG_CODE`)
)COMMENT = '배송';


-- 수취인
CREATE TABLE `RCPI`
(   `PLG_CODE`    INT  NOT NULL COMMENT '후원 코드',
    `RCPI_NAME`    VARCHAR(51) NOT NULL COMMENT '이름',
    `RCPI_PHONE`    VARCHAR(13) NOT NULL COMMENT '전화번호',
    `RCPI_ADD`    VARCHAR(255) NOT NULL COMMENT '주소',
 PRIMARY KEY ( `PLG_CODE` ),
 FOREIGN KEY (`PLG_CODE`) REFERENCES PLG (`PLG_CODE`)
)COMMENT = '수취인';

-- 신고
CREATE TABLE `RPT`
(   `RPT_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '신고 코드',
		`FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
		`USER_ID`    VARCHAR(15) NOT NULL COMMENT '신고자 아이디',
    `RPT_TITLE`    VARCHAR(60) NOT NULL COMMENT '신고 제목',
		`RPT_CONT`    VARCHAR(3000) NOT NULL COMMENT '신고 내용',
		`RPT_PRG_STAT`    VARCHAR(1) DEFAULT 'P' NOT NULL COMMENT '신고 진행 상태',
		`RPT_INSERT_DTTM`    DATETIME DEFAULT NOW() NOT NULL COMMENT '신고 등록 일시',
		`RPT_EMAIL`    VARCHAR(100) COMMENT '신고 답변 이메일',
    `STLMT_ANS`    VARCHAR(3000) COMMENT '신고 답변 내용',
 PRIMARY KEY ( `RPT_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`),
 FOREIGN KEY (`USER_ID`) REFERENCES USER (`USER_ID`)
)COMMENT = '신고';


-- 문의
CREATE TABLE `INQ`
(   `INQ_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '문의 코드',
		`FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
		`INQ_TITLE`   VARCHAR(60) NOT NULL COMMENT '문의 제목',
	  `INQ_CONT`   VARCHAR(3000) NOT NULL COMMENT '문의 내용',
	  `INQ_INSERT_DTTM`   DATETIME NOT NULL COMMENT '문의 등록 일시',
	  `INQ_EMAIL`   VARCHAR(100) COMMENT '문의 답변 이메일',
	  `INQ_ANS`   VARCHAR(3000) COMMENT '문의 답변 내용',
 PRIMARY KEY ( `INQ_CODE` ),
 FOREIGN KEY (`FND_CODE`) REFERENCES AUD (`FND_CODE`)
)COMMENT = '문의';


-- 문의 정보 파일
CREATE TABLE `INQ_FILE`
(   `FILE_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '파일 코드',
		`INQ_CODE`    INT NOT NULL COMMENT '문의 코드',
		`INQ_FILE_LOC`   VARCHAR(255) NOT NULL COMMENT '파일 저장 경로',
	  `INQ_ORG_FILE`   VARCHAR(255) NOT NULL COMMENT '기존 파일명',
	  `INQ_SAVE_FILE`   VARCHAR(36) NOT NULL COMMENT '저장 파일명',
 PRIMARY KEY ( `FILE_CODE` ),
 FOREIGN KEY (`INQ_CODE`) REFERENCES INQ (`INQ_CODE`)
)COMMENT = '문의 정보 파일';


-- 공지
CREATE TABLE `NTC`
(   `NTC_CODE`    INT AUTO_INCREMENT NOT NULL COMMENT '공지 코드',
    `NTC_TITLE`    VARCHAR(60) NOT NULL COMMENT '공지 제목',
		`NTC_CONT`    VARCHAR(3000) NOT NULL COMMENT '공지 내용',
    `NTC_INSERT_DT`    DATE NOT NULL COMMENT '공지 등록 일자',
 PRIMARY KEY ( `NTC_CODE` )
)COMMENT = '공지';


-- 찜한 펀딩
CREATE TABLE `WISHLIST`
(   `USER_ID`    VARCHAR(15) NOT NULL COMMENT '아이디',
    `FND_CODE`    INT NOT NULL COMMENT '펀딩 코드',
 PRIMARY KEY (`USER_ID`, `FND_CODE`),
 FOREIGN KEY (`USER_ID`) REFERENCES USER (`USER_ID`),
 FOREIGN KEY (`FND_CODE`) REFERENCES FND_INFO (`FND_CODE`)
)COMMENT = '찜한 펀딩';


