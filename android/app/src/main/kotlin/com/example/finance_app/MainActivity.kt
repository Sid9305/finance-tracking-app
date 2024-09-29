package com.example.finance_app

import android.provider.Telephony
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterFragmentActivity
import java.util.Calendar

class MainActivity: FlutterFragmentActivity() {
    private lateinit var methodChannelResult: MethodChannel.Result
    private val list = mutableListOf<String>()

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted: Boolean ->
        if (isGranted) {
            readSms()
        } else {
            Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show()
        }
    }

    // Function to read today's SMS
    private fun readSms() {
        val todayStartTime = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis

        val todayEndTime = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 23)
            set(Calendar.MINUTE, 59)
            set(Calendar.SECOND, 59)
            set(Calendar.MILLISECOND, 999)
        }.timeInMillis

        val cursor = contentResolver.query(
            Telephony.Sms.CONTENT_URI,
            null,
            "${Telephony.Sms.DATE} >= ? AND ${Telephony.Sms.DATE} <= ?",
            arrayOf(todayStartTime.toString(), todayEndTime.toString()),
            null
        )
        
        if (cursor != null && cursor.moveToFirst()) {
            do {
                val address = cursor.getString(cursor.getColumnIndexOrThrow(Telephony.Sms.ADDRESS))
                val body = cursor.getString(cursor.getColumnIndexOrThrow(Telephony.Sms.BODY))
                list.add("Sender: $address \nMessage: $body")
            } while (cursor.moveToNext())
        }
        cursor?.close()

        // Return the list of messages to the Flutter side
        methodChannelResult.success(list.toString())
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "smsPlatform"
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result
            when (call.method) {
                "readAllSms" -> {
                    requestPermissionLauncher.launch(android.Manifest.permission.READ_SMS)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
