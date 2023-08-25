import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'

const _FCMServerKey_ = Deno.env.get('FCM_SERVER_KEY')!
const _FCMEndpoint_ = "https://fcm.googleapis.com/fcm/send"

serve(async (req) => {
  try {
    const { record } = await req.json()

    // Build FCM notification object
    const message = {
        notification: {
            "title": record.headings,
            "body": record.content
        },
        priority: "high",
        data: {
            "landing_route": record.landing_route,
            "search_text": record.search_text,
            "created_at": record.created_at,
        },
        to: "/topics/all"
    }

    const headers = new Headers()
    headers.set('Authorization', `key=${_FCMServerKey_}`)
    headers.set('Content-Type', 'application/json')

    const fcmResponse = await fetch(_FCMEndpoint_, {
      method: 'POST',
      headers: headers,
      body: JSON.stringify(message)
    })

    const fcmResData = await fcmResponse.json()

    return new Response(JSON.stringify({ fcmResponse: fcmResData }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err) {
    console.error('Failed to send FCM notification', err)
    const errorMsg = `
    FCM_SERVER_KEY: ${_FCMServerKey_}
    Server Error:: ${err.toString()}
    `
    return new Response(errorMsg, {
      headers: { 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})