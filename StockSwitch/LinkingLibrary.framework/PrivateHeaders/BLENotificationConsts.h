/**
 * Copyright © 2015-2016 NTT DOCOMO, INC. All Rights Reserved.
 */

#import <Foundation/Foundation.h>
/**
 プロファイルNotificationの定数クラス
 */
@interface BLENotificationConsts : NSObject

// Message ID definition
extern const char BLENotificationMessageidConfirmNotifyCategory;
extern const char BLENotificationMessageidConfirmNotifyCategoryResp;
extern const char BLENotificationMessageidNotifyInformation;
extern const char BLENotificationMessageidGetPdNotifyDetailData;
extern const char BLENotificationMessageidGetPdNotifyDetailDataResp;
extern const char BLENotificationMessageidNotify_Pd_GeneralInformation;
extern const char BLENotificationMessageidStartPdApplication;
extern const char BLENotificationMessageidStartPdApplicationResp;

// ParameterID definition
extern const char BLENotificationParamidResultCode;
extern const char BLENotificationParamidCancel;
extern const char BLENotificationParamidGetStatus;
extern const char BLENotificationParamidNotifyCategory;
extern const char BLENotificationParamidNotifyCategoryid;
extern const char BLENotificationParamidGetParameterid;
extern const char BLENotificationParamidGetParameterLength;
extern const char BLENotificationParamidParameteridList;
extern const char BLENotificationParamidUniqueid;
extern const char BLENotificationParamidNotifyid;
extern const char BLENotificationParamidNotificationOperation;
extern const char BLENotificationParamidTitle;
extern const char BLENotificationParamidText;
extern const char BLENotificationParamidAppName;
extern const char BLENotificationParamidAppNameLocal;
extern const char BLENotificationParamidNotifyApp;
extern const char BLENotificationParamidRumblingSetting;
extern const char BLENotificationParamidVibrationPattern;
extern const char BLENotificationParamidLedPattern;
extern const char BLENotificationParamidSender;
extern const char BLENotificationParamidSenderAddress;
extern const char BLENotificationParamidReceiveData;
extern const char BLENotificationParamidStartDate;
extern const char BLENotificationParamidEndDate;
extern const char BLENotificationParamidArea;
extern const char BLENotificationParamidPerson;
extern const char BLENotificationParamidMimeTypeForImage;
extern const char BLENotificationParamidMimeTypeForMedia;
extern const char BLENotificationParamidImage;
extern const char BLENotificationParamidContents1;
extern const char BLENotificationParamidContents2;
extern const char BLENotificationParamidContents3;
extern const char BLENotificationParamidContents4;
extern const char BLENotificationParamidContents5;
extern const char BLENotificationParamidContents6;
extern const char BLENotificationParamidContents7;
extern const char BLENotificationParamidContents8;
extern const char BLENotificationParamidContents9;
extern const char BLENotificationParamidContents10;
extern const char BLENotificationParamidMedia;
extern const char BLENotificationParamidPackage;
extern const char BLENotificationParamidClass;
extern const char BLENotificationParamidSharingInformation;

// Result code
extern const char BLENotificationResultOk;
extern const char BLENotificationResultCancel;
extern const char BLENotificationResultErrorFailed;
extern const char BLENotificationResultErrorNoReason;
extern const char BLENotificationResultErrorDataNotAvailable;
extern const char BLENotificationResultErrorNotSupported;
extern const char BLENotificationResultReserved;  // greater than or equal to

// Cancel
extern const char BLENotificationCancelUserCancel;
extern const char BLENotificationCancelReserved;  // greater than or equal to

// GetStatus
extern const char BLENotificationGetStatusOkAll;
extern const char BLENotificationGetStatusOkPartially;
extern const char BLENotificationGetStatusCancel;
extern const char BLENotificationGetStatusErrorFailed;
extern const char BLENotificationGetStatusErrorNoReason;
extern const char BLENotificationGetStatusErrorDataNotAvailable;
extern const char BLENotificationGetStatusErrorNotSupported;
extern const char BLENotificationGetStatusReserved;  // greater than or equal to

// low bit
extern const char BLENotificationNotifyCategoryLbNotNotify;
extern const char BLENotificationNotifyCategoryLbALL;
extern const char BLENotificationNotifyCategoryLbPhoneInComingCall;
extern const char BLENotificationNotifyCategoryLbPhoneInCall;
extern const char BLENotificationNotifyCategoryLbPhoneIdle;
extern const char BLENotificationNotifyCategoryLbMail;
extern const char BLENotificationNotifyCategoryLbSchedule;
extern const char BLENotificationNotifyCategoryLbGeneral;

// heigh bit
extern const char BLENotificationNotifyCategoryHbEtc;

// NotificationOperation
extern const char BLENotificationNotificationOperationAllReadyRead;
extern const char BLENotificationNotificationOperationDelete;

// RumblingSetting
extern const char BLENotificationRumblingSettingNone;
extern const char BLENotificationRumblingSettingLed;
extern const char BLENotificationRumblingSettingVibration;
extern const char BLENotificationRumblingSettingLEDVibration;

// ParameterIdList
extern const char BLENotificationParameterIdListPhoneInComingCallLbSenderPhoneNumber;
extern const char BLENotificationParameterIdListPhoneInComingCallLbNotifyId;
extern const char BLENotificationParameterIdListPhoneInComingCallLbNotifyCategoryId;

extern const char BLENotificationParameterIdListPhoneInCallLbSenderPhoneNumber;
extern const char BLENotificationParameterIdListPhoneInCallLbNotifyId;
extern const char BLENotificationParameterIdListPhoneInCallLbNotifyCategoryId;

extern const char BLENotificationParameterIdListPhoneIdleLbSenderPhoneNumber;
extern const char BLENotificationParameterIdListPhoneIdleLbNotifyId;
extern const char BLENotificationParameterIdListPhoneIdleLbNotifyCategoryId;

extern const char BLENotificationParameterIdListMailLbAppName;
extern const char BLENotificationParameterIdListMailLbAPPNameLocal;
extern const char BLENotificationParameterIdListMailLbPackage;
extern const char BLENotificationParameterIdListMailLbTitle;
extern const char BLENotificationParameterIdListMailLbText;
extern const char BLENotificationParameterIdListMailLbSender;
extern const char BLENotificationParameterIdListMailLbSenderAddress;
extern const char BLENotificationParameterIdListMailLbReceiveDate;
extern const char BLENotificationParameterIdListMailHbNotifyId;
extern const char BLENotificationParameterIdListMailHbNotifyCategoryId;

extern const char BLENotificationParameterIdListScheduleLbAppName;
extern const char BLENotificationParameterIdListScheduleLbAPPNameLocal;
extern const char BLENotificationParameterIdListScheduleLbPackage;
extern const char BLENotificationParameterIdListScheduleLbTitle;
extern const char BLENotificationParameterIdListScheduleLbStartDate;
extern const char BLENotificationParameterIdListScheduleLbEndDate;
extern const char BLENotificationParameterIdListScheduleLbArea;
extern const char BLENotificationParameterIdListScheduleLbPerson;
extern const char BLENotificationParameterIdListScheduleHbText;
extern const char BLENotificationParameterIdListScheduleHbContents1;
extern const char BLENotificationParameterIdListScheduleHbContents2;
extern const char BLENotificationParameterIdListScheduleHbContents3;
extern const char BLENotificationParameterIdListScheduleHbNotifyId;
extern const char BLENotificationParameterIdListScheduleHbNotifyCategoryId;

extern const char BLENotificationParameterIdListGeneralLbAppName;
extern const char BLENotificationParameterIdListGeneralLbAppNameLocal;
extern const char BLENotificationParameterIdListGeneralLbPackage;
extern const char BLENotificationParameterIdListGeneralLbTitle;
extern const char BLENotificationParameterIdListGeneralLbText;
extern const char BLENotificationParameterIdListGeneralLbIcon;
extern const char BLENotificationParameterIdListGeneralLbNotifyId;
extern const char BLENotificationParameterIdListGeneralLbNotifyCategoryId;

extern const char BLENotificationParameterIdListEtcLbAppName;
extern const char BLENotificationParameterIdListEtcLbAppNameLocal;
extern const char BLENotificationParameterIdListEtcLbPackage;
extern const char BLENotificationParameterIdListEtcLbContents1;
extern const char BLENotificationParameterIdListEtcLbContents2;
extern const char BLENotificationParameterIdListEtcLbContents3;
extern const char BLENotificationParameterIdListEtcLbContents4;
extern const char BLENotificationParameterIdListEtcLbContents5;
extern const char BLENotificationParameterIdListEtcHbContents6;
extern const char BLENotificationParameterIdListEtcHbContents7;
extern const char BLENotificationParameterIdListEtcHbMimeTypeForMedia;
extern const char BLENotificationParameterIdListEtcHbMedia;
extern const char BLENotificationParameterIdListEtcHbMimeTypeForImage;
extern const char BLENotificationParameterIdListEtcHbImage;
extern const char BLENotificationParameterIdListEtcHbNotifyId;
extern const char BLENotificationParameterIdListEtcHbNotifyCategoryId;

@end