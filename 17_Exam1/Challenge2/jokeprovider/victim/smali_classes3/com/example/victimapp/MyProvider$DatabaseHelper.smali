.class Lcom/example/victimapp/MyProvider$DatabaseHelper;
.super Landroid/database/sqlite/SQLiteOpenHelper;
.source "MyProvider.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/example/victimapp/MyProvider;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "DatabaseHelper"
.end annotation


# direct methods
.method constructor <init>(Landroid/content/Context;)V
    .locals 3
    .param p1, "context"    # Landroid/content/Context;

    .line 96
    const/4 v0, 0x0

    const/4 v1, 0x1

    const-string v2, "JokeDB"

    invoke-direct {p0, p1, v2, v0, v1}, Landroid/database/sqlite/SQLiteOpenHelper;-><init>(Landroid/content/Context;Ljava/lang/String;Landroid/database/sqlite/SQLiteDatabase$CursorFactory;I)V

    .line 97
    return-void
.end method


# virtual methods
.method public onCreate(Landroid/database/sqlite/SQLiteDatabase;)V
    .locals 76
    .param p1, "db"    # Landroid/database/sqlite/SQLiteDatabase;

    .line 102
    move-object/from16 v0, p1

    const-string v1, " CREATE TABLE joke (id INTEGER PRIMARY KEY AUTOINCREMENT,  author TEXT NOT NULL,  joke TEXT NOT NULL);"

    .line 107
    .local v1, "CREATE_TABLE":Ljava/lang/String;
    invoke-virtual {v0, v1}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 108
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    .line 109
    .local v2, "values":Landroid/content/ContentValues;
    const-string v3, "0NoHtE"

    const-string v4, "2PUsKU"

    const-string v5, "0NoHtE"

    const-string v6, "2PUsKU"

    const-string v7, "2rGjhL"

    const-string v8, "3mVGKb"

    const-string v9, "4SFNbG"

    const-string v10, "6aTVgl"

    const-string v11, "8DAowt"

    const-string v12, "AR2XJM"

    const-string v13, "BAC1R3"

    const-string v14, "BAFEBq"

    const-string v15, "CRAsXY"

    const-string v16, "DFFFDm"

    const-string v17, "EsNTKA"

    const-string v18, "FN8euy"

    const-string v19, "FN8euy"

    const-string v20, "FvfHHq"

    const-string v21, "HqDHF7"

    const-string v22, "IvgUC3"

    const-string v23, "Ky9Sjg"

    const-string v24, "LXisay"

    const-string v25, "MKdRId"

    const-string v26, "MScG7g"

    const-string v27, "NPsxQF"

    const-string v28, "OYrIIs"

    const-string v29, "PP7ioC"

    const-string v30, "QYIf9W"

    const-string v31, "R5HaSj"

    const-string v32, "RpweHL"

    const-string v33, "TVxjVS"

    const-string v34, "U8EYcc"

    const-string v35, "UkGlOp"

    const-string v36, "VY3ebX"

    const-string v37, "Vj7gIx"

    const-string v38, "WURo1J"

    const-string v39, "YQTQ63"

    const-string v40, "YwqLXH"

    const-string v41, "Z8WOEv"

    const-string v42, "ZU7Qm4"

    const-string v43, "aTdi4a"

    const-string v44, "aZuYVW"

    const-string v45, "cCUYtS"

    const-string v46, "cEj6w7"

    const-string v47, "cX6CO7"

    const-string v48, "ceDKUj"

    const-string v49, "etUCvw"

    const-string v50, "fkZ7b5"

    const-string v51, "iFUIbF"

    const-string v52, "ilYDs2"

    const-string v53, "imWA8w"

    const-string v54, "jENbAH"

    const-string v55, "jnyVNP"

    const-string v56, "kNOh1J"

    const-string v57, "lZX24Y"

    const-string v58, "lvz9p1"

    const-string v59, "mNFlDw"

    const-string v60, "ne4tcA"

    const-string v61, "nyMI1z"

    const-string v62, "RqPLE"

    const-string v63, "elosiouk"

    const-string v64, "elosiouk"

    const-string v65, "elosiouk"

    const-string v66, "elosiouk"

    const-string v67, "s4ddQd"

    const-string v68, "s4ddQd"

    const-string v69, "sx3GNi"

    const-string v70, "tw7iTK"

    const-string v71, "wzgS7s"

    const-string v72, "xKxE5D"

    const-string v73, "y59cO1"

    const-string v74, "z6fTvN"

    filled-new-array/range {v3 .. v74}, [Ljava/lang/String;

    move-result-object v3

    .line 115
    .local v3, "authors":[Ljava/lang/String;
    const-string v4, "mgSehB"

    const-string v5, "1Mrj51"

    const-string v6, "mgSehB"

    const-string v7, "1Mrj51"

    const-string v8, "qw3L4C"

    const-string v9, "gaRaQG"

    const-string v10, "rnMWvZ"

    const-string v11, "0vybRn"

    const-string v12, "7az8oj"

    const-string v13, "QYKJwE"

    const-string v14, "XWO7ii"

    const-string v15, "5IB80Z"

    const-string v16, "WZsiMf"

    const-string v17, "if9aAa"

    const-string v18, "ZpPEBe"

    const-string v19, "PbNnOS"

    const-string v20, "UmbXVR"

    const-string v21, "W3ao4i"

    const-string v22, "70MudB"

    const-string v23, "Xh3C4q"

    const-string v24, "KxTMTl"

    const-string v25, "DD8Sno"

    const-string v26, "x5llk9"

    const-string v27, "bXPlED"

    const-string v28, "4cIJPr"

    const-string v29, "nifYDC"

    const-string v30, "sfWQ4k"

    const-string v31, "JvT02S"

    const-string v32, "onaite"

    const-string v33, "MIOy0g"

    const-string v34, "cEsij0"

    const-string v35, "HdzEQo"

    const-string v36, "Snilsv"

    const-string v37, "5HhIdC"

    const-string v38, "vJAOfv"

    const-string v39, "Mgyuw7"

    const-string v40, "q1wvgZ"

    const-string v41, "CKSaDh"

    const-string v42, "4OoEYn"

    const-string v43, "8kW7WJ"

    const-string v44, "tVhP7d"

    const-string v45, "bZiFsv"

    const-string v46, "trVyOk"

    const-string v47, "1Pjj3B"

    const-string v48, "Snt9Rd"

    const-string v49, "zCvltI"

    const-string v50, "KLTk6X"

    const-string v51, "9LSmUd"

    const-string v52, "ggt5hV"

    const-string v53, "Ulx7oa"

    const-string v54, "igd3x9"

    const-string v55, "Ojikf7"

    const-string v56, "d5aBg3"

    const-string v57, "i27u8h"

    const-string v58, "3A8aTi"

    const-string v59, "4lG7nu"

    const-string v60, "sYMlgH"

    const-string v61, "MsA91m"

    const-string v62, "yEijJ1"

    const-string v63, "O3jTfG"

    const-string v64, "FLAG{Homo"

    const-string v65, "_faber_"

    const-string v66, "fortunae_"

    const-string v67, "suae}"

    const-string v68, "xwx7on"

    const-string v69, "Aa3Sdx"

    const-string v70, "9wLFgG"

    const-string v71, "JgEO6D"

    const-string v72, "cLD1LW"

    const-string v73, "wYU4h3"

    const-string v74, "mxjYsB"

    const-string v75, "2nAS26"

    filled-new-array/range {v4 .. v75}, [Ljava/lang/String;

    move-result-object v4

    .line 120
    .local v4, "jokes":[Ljava/lang/String;
    const/4 v5, 0x0

    .local v5, "i":I
    :goto_0
    array-length v6, v3

    if-ge v5, v6, :cond_0

    .line 121
    const-string v6, "author"

    aget-object v7, v3, v5

    invoke-virtual {v2, v6, v7}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 122
    aget-object v6, v4, v5

    const-string v7, "joke"

    invoke-virtual {v2, v7, v6}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 123
    const/4 v6, 0x0

    invoke-virtual {v0, v7, v6, v2}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    .line 120
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 126
    .end local v5    # "i":I
    :cond_0
    return-void
.end method

.method public onUpgrade(Landroid/database/sqlite/SQLiteDatabase;II)V
    .locals 1
    .param p1, "db"    # Landroid/database/sqlite/SQLiteDatabase;
    .param p2, "oldVersion"    # I
    .param p3, "newVersion"    # I

    .line 130
    const-string v0, "DROP TABLE IF EXISTS joke"

    invoke-virtual {p1, v0}, Landroid/database/sqlite/SQLiteDatabase;->execSQL(Ljava/lang/String;)V

    .line 131
    invoke-virtual {p0, p1}, Lcom/example/victimapp/MyProvider$DatabaseHelper;->onCreate(Landroid/database/sqlite/SQLiteDatabase;)V

    .line 132
    return-void
.end method
