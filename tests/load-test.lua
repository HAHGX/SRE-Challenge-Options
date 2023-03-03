wrk.method = "POST"
wrk.body   = "fecha=2019-01-01&hora=10:30&vlo=123&ori=SCL&des=MEX&emp=LATAM&dianom=Lunes&tipo_vuelo=I&opera=LATAM&siglaori=Santiago&siglades=Mexico"
wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"

function setup(thread)
    thread:set("Authorization", "Bearer <TOKEN>")
end
-- reemplazar token por token propio