### Decode JSON + запрет неизвестных полей

Прочитайте JSON `{"id":1,"name":"buy milk"}` в структуру в handler и запретите неизвестные поля.

```go
type Task struct {
	// TODO
}

func myHandler(w http.ResponseWriter, r *http.Request) {
    // TODO
	if err != nil {
        http.Error(w, "bad json", http.StatusBadRequest)
        return
    }
}
```

### Encode JSON response
Верните JSON `{"ok":true}` со статусом 200 и `Content-Type: application/json`.

```go
func okHandler(w http.ResponseWriter, r *http.Request) {
    // TODO
}
```

### Path param (Go 1.22+): прочитать {id}

В handler для `GET /notes/{id}` получите id через `r.PathValue("id")`, распарсьте в int64, при ошибке верните 400.

```go
func getNote(w http.ResponseWriter, r *http.Request) {
    // TODO
	id, err := strconv.ParseInt(idStr, 10, 64)
	// TODO
}
```

### Query params: limit/offset с дефолтами
Достаньте limit и offset из query, дефолты: limit=20, offset=0. limit ограничьте 1..100.

```go
func list(w http.ResponseWriter, r *http.Request) {
// TODO
}
```

### Единый формат ошибки (JSON envelope)
Реализуйте `writeError(w, status, code, msg, requestID)` который пишет:

```json
    {"error":{"code":"...","message":"..."},"request_id":"..."}
```

```go
func writeError(w http.ResponseWriter, status int, code, msg, requestID string) {
    // TODO
}

```

### Middleware: request id (HTTP)
Напишите middleware: берёт X-Request-Id из запроса или генерирует новый (16 байт random hex), кладёт в context, и выставляет в response header.

```go
type ctxKeyReqID struct{}

func RequestID(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // TODO
		b := make([]byte, 16)
        _, _ = rand.Read(b)
        rid = hex.EncodeToString(b)
		// TODO
    }
}
```

### Middleware: recover panic -> 500
Напишите middleware, который ловит panic и возвращает 500.

```go
func Recover(next http.Handler) http.Handler {
    // TODO
	defer func() {
        if rec := recover(); rec != nil {
            // TODO
        }
    }()
	// TODO
}
```