.class public Lcom/example/victimapp/MyProvider;
.super Landroid/content/ContentProvider;
.source "MyProvider.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/example/victimapp/MyProvider$DatabaseHelper;
    }
.end annotation


# static fields
.field static final COLUMN_AUTHOR:Ljava/lang/String; = "author"

.field static final COLUMN_JOKE:Ljava/lang/String; = "joke"

.field static final CONTENT_URI:Landroid/net/Uri;

.field static final DATABASE_NAME:Ljava/lang/String; = "JokeDB"

.field private static final DATABASE_VERSION:I = 0x1

.field static final PROVIDER_NAME:Ljava/lang/String; = "com.example.victimapp.MyProvider"

.field static final TABLE_NAME:Ljava/lang/String; = "joke"

.field static final URL:Ljava/lang/String; = "content://com.example.victimapp.MyProvider/joke"

.field static final uriCode:I = 0x1

.field static final uriMatcher:Landroid/content/UriMatcher;


# instance fields
.field private db:Landroid/database/sqlite/SQLiteDatabase;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 25
    const-string v0, "content://com.example.victimapp.MyProvider/joke"

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/example/victimapp/MyProvider;->CONTENT_URI:Landroid/net/Uri;

    .line 30
    new-instance v0, Landroid/content/UriMatcher;

    const/4 v1, -0x1

    invoke-direct {v0, v1}, Landroid/content/UriMatcher;-><init>(I)V

    sput-object v0, Lcom/example/victimapp/MyProvider;->uriMatcher:Landroid/content/UriMatcher;

    .line 31
    const-string v1, "joke"

    const/4 v2, 0x1

    const-string v3, "com.example.victimapp.MyProvider"

    invoke-virtual {v0, v3, v1, v2}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    .line 32
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 21
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    return-void
.end method


# virtual methods
.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 1
    .param p1, "uri"    # Landroid/net/Uri;
    .param p2, "s"    # Ljava/lang/String;
    .param p3, "strings"    # [Ljava/lang/String;

    .line 83
    const/4 v0, 0x0

    return v0
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 1
    .param p1, "uri"    # Landroid/net/Uri;

    .line 72
    const/4 v0, 0x0

    return-object v0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 3
    .param p1, "uri"    # Landroid/net/Uri;
    .param p2, "values"    # Landroid/content/ContentValues;

    .line 78
    new-instance v0, Landroid/database/sqlite/SQLiteException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Failed to add a record into "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/database/sqlite/SQLiteException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public onCreate()Z
    .locals 3

    .line 49
    invoke-virtual {p0}, Lcom/example/victimapp/MyProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 50
    .local v0, "context":Landroid/content/Context;
    new-instance v1, Lcom/example/victimapp/MyProvider$DatabaseHelper;

    invoke-direct {v1, v0}, Lcom/example/victimapp/MyProvider$DatabaseHelper;-><init>(Landroid/content/Context;)V

    .line 51
    .local v1, "dbHelper":Lcom/example/victimapp/MyProvider$DatabaseHelper;
    invoke-virtual {v1}, Lcom/example/victimapp/MyProvider$DatabaseHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v2

    iput-object v2, p0, Lcom/example/victimapp/MyProvider;->db:Landroid/database/sqlite/SQLiteDatabase;

    .line 52
    if-eqz v2, :cond_0

    const/4 v2, 0x1

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    :goto_0
    return v2
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 9
    .param p1, "uri"    # Landroid/net/Uri;
    .param p2, "projection"    # [Ljava/lang/String;
    .param p3, "selection"    # Ljava/lang/String;
    .param p4, "selectionArgs"    # [Ljava/lang/String;
    .param p5, "sortOrder"    # Ljava/lang/String;

    .line 58
    invoke-virtual {p0}, Lcom/example/victimapp/MyProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {p0}, Lcom/example/victimapp/MyProvider;->getCallingPackage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Lcom/example/victimapp/MyProvider;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/pm/PackageManager;->checkSignatures(Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    if-nez v0, :cond_0

    .line 59
    new-instance v0, Landroid/database/sqlite/SQLiteQueryBuilder;

    invoke-direct {v0}, Landroid/database/sqlite/SQLiteQueryBuilder;-><init>()V

    .line 60
    .local v0, "qb":Landroid/database/sqlite/SQLiteQueryBuilder;
    const-string v1, "joke"

    invoke-virtual {v0, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 61
    iget-object v2, p0, Lcom/example/victimapp/MyProvider;->db:Landroid/database/sqlite/SQLiteDatabase;

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v1, v0

    move-object v3, p2

    move-object v4, p3

    move-object v5, p4

    move-object v8, p5

    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteQueryBuilder;->query(Landroid/database/sqlite/SQLiteDatabase;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 63
    .local v1, "c":Landroid/database/Cursor;
    invoke-virtual {p0}, Lcom/example/victimapp/MyProvider;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-interface {v1, v2, p1}, Landroid/database/Cursor;->setNotificationUri(Landroid/content/ContentResolver;Landroid/net/Uri;)V

    .line 64
    return-object v1

    .line 66
    .end local v0    # "qb":Landroid/database/sqlite/SQLiteQueryBuilder;
    .end local v1    # "c":Landroid/database/Cursor;
    :cond_0
    const/4 v0, 0x0

    return-object v0
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 1
    .param p1, "uri"    # Landroid/net/Uri;
    .param p2, "contentValues"    # Landroid/content/ContentValues;
    .param p3, "s"    # Ljava/lang/String;
    .param p4, "strings"    # [Ljava/lang/String;

    .line 88
    const/4 v0, 0x0

    return v0
.end method
