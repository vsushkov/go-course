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

В handler для `GET /notes/{id}` получите id, распарсьте в int64, при ошибке верните 400.

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

### ResponseWriter wrapper: логировать status code
Реализуйте statusWriter, который запоминает status code.

```go
type statusWriter struct {
    http.ResponseWriter
    status int
}

func (sw *statusWriter) WriteHeader(code int) {
    // TODO
}
```

### Валидация: required + max len
Напишите Validate(). Правила: email required, name max 50 (trim spaces). Возвращайте map[string]string.

```go
type CreateUserRequest struct {
    Email string json:"email"
    Name  string json:"name"
}

func (r CreateUserRequest) Validate() map[string]string {
	// TODO

    return errs
}
```

### Enum validation
Проверьте, что role ∈ {"user","admin"}.

```go
func validateRole(role string) error {
    // TODO
}
```

### ETag: сформировать из версии
Напишите функцию `etagFromVersion(v int64) string`, которая возвращает строку в формате "v<число>".

### If-Match проверка
В handler проверьте If-Match (обязателен). Если пустой -> 428, если не равен currentETag -> 412.

```go
func checkIfMatch(w http.ResponseWriter, r *http.Request, currentETag string) bool {
    // TODO return true if ok
}
```

### database/sql: CreateNote
Реализуйте метод репозитория:

```go

type Note struct{ ID int64; Title, Body string; CreatedAt time.Time }
type Repo struct{ db *sql.DB }

func (r *Repo) CreateNote(ctx context.Context, title, body string) (Note, error) {
    // TODO
}
```

### Обработка sql.ErrNoRows -> ErrNotFound
Допишите обработку sql.ErrNoRows.

```go
var ErrNotFound = errors.New("not found")

// mapNoRows is called after a call to db.QueryRow + Row.Scan
func mapNoRows(err error) error {
    // TODO
}
```

### Транзакция: insert note + insert note_events
Внутри CreateNoteWithEvent сделайте транзакцию: insert note, затем insert event, commit.

```go
func (r *Repo) CreateNoteWithEvent(ctx context.Context, title, body, actorID string) (Note, error) {
    // TODO
    err = tx.QueryRowContext(ctx, `
        INSERT INTO notes(title, body) VALUES ($1,$2)
        RETURNING id, title, body, created_at
    `, title, body).Scan(&n.ID, &n.Title, &n.Body, &n.CreatedAt)
    if err != nil {
        return Note{}, err
    }
    // TODO
    return n, nil
}
```

### Concurrency: безопасный счётчик
Исправьте гонку данных: 100 горутин инкрементируют count.

```go
var count int

func inc100() {
    // TODO
	for i := 0; i < 100; i++ {
        go func () {
			// TODO
            count++
			// TODO
        }()
    }
	// TODO
}

```

### Worker pool: обработать jobs и собрать results
Запустите 2 воркера, которые читают `jobs <-chan int` и пишут квадрат в `results chan<- int`.

```go
func startWorkers(jobs <-chan int, results chan<- int) {
    // TODO
}
```

### Bounded queue + backpressure
Реализуйте добавление в очередь без блокировки: если очередь полна — вернуть ошибку.

```go
var ErrFull = errors.New("queue full")

type Q struct{ ch chan int }

func (q *Q) Enqueue(v int) error {
    // TODO
}
```

### Shutdown воркеров без context: drain + timeout
Реализуйте Shutdown(timeout) для воркеров: закрыть канал, ждать wg с таймаутом.

```go
type Indexer struct {
    jobs chan int // канал для заданий на индексацию
    wg   sync.WaitGroup // при добавлении нового задания на индексацю, увеличиваем счетчик в этой WaitGroup
    mu   sync.Mutex
    closed bool // флаг, что больше новых заданий не принимаем
}

func (ix *Indexer) Shutdown(timeout time.Duration) error {
    ix.mu.Lock()
    if ix.closed {
        ix.mu.Unlock()
        return nil
    }
    
    // TODO
}
```

### Context timeout middleware (HTTP)
Реализовать middleware: оборачивает r.Context() в context.WithTimeout(2s) и передаёт дальше.

```go
func Timeout(next http.Handler) http.Handler {
    // TODO
}
```

### Cancellation-aware work
Функция делает 5 шагов по 200ms, но должна прерываться по ctx.Done().

```go
func doWork(ctx context.Context) error {
    // TODO
}
```

### Parallel subcalls: отменить остальные при ошибке
Запустите a(ctx) и b(ctx) параллельно с общим ctx. Если один вернул ошибку — отменить другой и вернуть ошибку.

```go
func a(ctx context.Context) error { return nil }
func b(ctx context.Context) error { return nil }

func runBoth(parent context.Context) error {
    ctx, cancel := context.WithCancel(parent)
    // TODO
}
```

### gRPC: unary interceptor logging method + code
Напишите unary interceptor, который логирует info.FullMethod и status.Code(err).

```go
func LoggingUnary(l *slog.Logger) grpc.UnaryServerInterceptor {
    return func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
    }
}
```

### gRPC: извлечь authorization из metadata
Достаньте authorization из incoming metadata и верните token без префикса Bearer .

```go
func bearerFromMD(ctx context.Context) (string, error) {
}
```

### gRPC: вернуть NotFound
Верните gRPC ошибку NotFound с сообщением "note not found".

```go
func notFoundErr() error {
    // TODO
}
```

### HTTP handler test: httptest + JSON body
Напишите тест, который вызывает handler POST /echo с JSON {"x":1} и проверяет статус 200.

```go
func TestEcho(t *testing.T) {
    // TODO

    handler.ServeHTTP(w, r)

    // TODO
}
```


### slog: logger с группой и attrs
Создайте slog.Logger, который пишет JSON в stdout, уровень Info, и логируйте два сообщения.
При этом к обоим сообщениям добавить одинаковые аргументы, но без дублирования кода.

```go
func demo() {
    h := slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelInfo})
    log := slog.New(h)

	// TODO
}
```
