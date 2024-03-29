﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 权限点枚举
    /// </summary>
    public enum AuthLimitEnum
    {
        ContractsModifyInternalCost = 1,
        ContractsModifyServiceBundle = 2,
        ContractsCreateInvoice = 3,
        ContractsApprovePost = 4,

        CRMCompanyViewCustomer = 51,
        CRMCompanyViewVerdor = 52,
        CRMCompanyViewProspect = 53,
        CRMCompanyAdd = 54,
        CRMCompanyEdit = 55,
        CRMCompanyDelete = 56,
        CRMOpportunityQuoteView = 57,
        CRMOpportunityQuoteAdd = 58,
        CRMOpportunityQuoteEdit = 59,
        CRMOpportunityQuoteDelete = 60,
        CRMSalesOrderView = 61,
        CRMSalesOrderEdit = 62,
        CRMSalesOrderDelete = 63,
        CRMConfItemSubscrptView = 64,
        CRMConfItemSubscrptAdd = 65,
        CRMConfItemSubscrptEdit = 66,
        CRMConfItemSubscrptDelete = 67,
        CRMNotesView = 68,
        CRMNotesAdd = 69,
        CRMNotesEdit = 70,
        CRMNotesDelete = 71,
        CRMTodoView = 72,
        CRMTodoAdd = 73,
        CRMTodoEdit = 74,
        CRMTodoDelete = 75,
        CRMAttachmentView = 76,
        CRMAttachmentAdd = 77,
        CRMAttachmentDelete = 78,
        CRMContactGroupManage = 79,
        CRMReportExport = 80,
        CRMDeviceDiscoveryWizard = 81,
        CRMCanManageQuote = 82,
        CRMCanModifyAccountManager = 83,
        CRMCanModifyOpportunityOwner = 84,
        CRMDisplayAllCompany = 85,
        CRMDashboardDisplay = 86,

        INVLocationView = 101,
        INVLocationAddEdit = 102,
        INVLocationDelete = 103,
        INVItemView = 104,
        INVItemAddEdit = 105,
        INVItemDelete = 106,
        INVProductsView = 107,
        INVProductsAddEdit = 108,
        INVProductsDelete = 109,
        INVPurchaseOrdersView = 110,
        INVPurchaseOrdersAddEdit = 111,
        INVPurchaseOrdersDelete = 112,
        INVApporveRejectItems = 113,
        INVReceiveItems = 114,
        INVDeliverShipItems = 115,
        INVTransferItems = 116,

        PROClientView = 151,
        PROClientAdd = 152,
        PROProposalView = 153,
        PROProposalAdd = 154,
        PROTemplatesView = 155,
        PROTemplatesAdd = 156,
        PROCanModifyContract = 157,
        PROCanModifyNonBillable = 158,
        PROCanModifyShow = 159,
        PROCanModifyWorkType = 160,
        PROCanModifyService = 161,
        PROCanEnterTime = 162,
        PROCanViewInternalCostData = 163,

        SERTicketsView = 201,
        SERTicketsAdd = 202,
        SERTicketsEdit = 203,
        SERTicketsDelete = 204,
        SERTicketNotesView = 205,
        SERTicketNotesAdd = 206,
        SERTicketNotesEdit = 207,
        SERTicketNotesDelete = 208,
        SERServiceCallsView = 209,
        SERServiceCallsAdd = 210,
        SERServiceCallsEdit = 211,
        SERServiceCallsDelete = 212,
        SERCanModifyContract = 213,
        SERCanModifyNonBillable = 214,
        SERCanModifyShow = 215,
        SERCanModifyWorkType = 216,
        SERCanModifyService = 217,
        SERCanEditStatus = 218,
        SERCanAccessDispatchCalendar = 219,
        SERCanViewInternalCostData = 220,

        TIMTimesheetModuleReports = 251,
        TIMTimeOffPayrollReports = 252,
        TIMPaidExportedTimesheet = 253,
        TIMCreateNewProjectTimeEntries = 254,

        ADMFullAccess = 301,
        ADMYourOrganization = 302,
        ADMResources = 303,
        ADMCompaniesContacts = 304,
        ADMServiceDesk = 305,
        ADMProjectsTasks = 306,
        ADMSalesOpportunities = 307,
        ADMProductsServices = 308,
        ADMConfItems = 309,
        ADMFinanceAccountInvoice = 310,
        ADMContract = 311,
        ADMLiveReports = 312,
        ADMAddOns = 313,
        ADMClientPortal = 314,
        ADMMicrosoftExt = 315,
        ADMQuickBooksExt = 316,
        ADMRemoteMonitoring = 317,
        ADMOtherExt = 318,

        OTHViewCompanyContactSurveyRating = 351,
        OTHViewResourceSurveyRating = 352,
        OTHAccessLiveReportsDesigner = 353,
        OTHManageLiveReportsFolder = 354,
        OTHPublishLiveReports = 355,
        OTHScheduleLiveReports = 356,
        OTHAddEditClientPortalSecLevel = 357,
        OTHAccessNewsFeed = 358,
        OTHAccessPublicTeamWalls = 359,
        OTHAccessPrivateTeamWalls = 360,
        OTHAccessCoWorker = 361,
        OTHAccessGlobalNotesSearch = 362,
        OTHAccessKnowledgebase = 363,
        OTHExportGridData = 364,
        OTHLoginWebAPI = 365,
        OTHManageSharedDashTabs = 366,
        OTHOfferDashWidgets = 367,
        OTHAccessExecutiveDash = 368,
        OTHAccessBillingPortal = 369,
    }

    /// <summary>
    /// 权限模块
    /// </summary>
    public enum ModuleEnum
    {

    }

    /// <summary>
    /// 权限对象类型
    /// </summary>
    public enum ObjectEnum
    {
        Account,
        Contact,
        Opportunity,
        Quote,
    }

    /// <summary>
    /// 操作类型
    /// </summary>
    public enum ActionEnum
    {
        Add,
        Edit,
        View,
        Delete,
    }
}
