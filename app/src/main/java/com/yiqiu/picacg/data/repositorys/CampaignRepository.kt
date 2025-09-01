package com.yiqiu.picacg.data.repositorys

import com.yiqiu.picacg.apis.CampaignApi
import com.yiqiu.picacg.data.dto.CampaignDTO
import retrofit2.Response

class CampaignRepository(private val api: CampaignApi) {
    suspend fun getAnnouncements(page: Int): Response<CampaignDTO.AnnouncementsResponse> =
        api.getAnnouncements(page)
}