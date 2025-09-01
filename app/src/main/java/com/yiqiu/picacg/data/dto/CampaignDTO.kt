package com.yiqiu.picacg.data.dto

import com.yiqiu.picacg.models.Announcement
import com.yiqiu.picacg.models.PageData

class CampaignDTO {
    class AnnouncementsResponse(
        val code: Int,
        val message: String,
        val data: AnnouncementPage
    )
}

data class AnnouncementPage(
    val announcements: PageData<Announcement> = PageData(
        total = 0,
        limit = 0,
        page = 0,
        pages = 0,
        docs = emptyList()
    )
)