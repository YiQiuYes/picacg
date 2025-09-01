package com.yiqiu.picacg.apis

import com.yiqiu.picacg.data.dto.CampaignDTO
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Query

interface CampaignApi {
    @GET("/announcements")
    suspend fun getAnnouncements(@Query("page") page: Int): Response<CampaignDTO.AnnouncementsResponse>
}