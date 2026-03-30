package com.checkin.check_in_reminder

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class CheckInWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            val status = widgetData.getString("status", "unknown") ?: "unknown"
            val lastTime = widgetData.getString("lastTime", "--:--") ?: "--:--"
            val locationName = widgetData.getString("locationName", "") ?: ""

            val statusText = when (status) {
                "inside" -> if (locationName.isNotEmpty()) "Inside $locationName" else "Inside range"
                "outside" -> if (locationName.isNotEmpty()) "Left $locationName" else "Outside range"
                else -> "Status unknown"
            }

            val timeText = when (status) {
                "inside" -> "Arrived: $lastTime"
                "outside" -> "Left: $lastTime"
                else -> "Last record: $lastTime"
            }

            views.setTextViewText(R.id.widget_status, statusText)
            views.setTextViewText(R.id.widget_last_time, timeText)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
