.class public Lcom/mobiotsec/nojumpstarts/C;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "C.java"


# static fields
.field private static expectedMsg:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 10
    const-string v0, "Main-to-A/A-to-B/B-to-C"

    sput-object v0, Lcom/mobiotsec/nojumpstarts/C;->expectedMsg:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private reply(Ljava/lang/String;)V
    .locals 2
    .param p1, "flag"    # Ljava/lang/String;

    .line 13
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    .line 14
    .local v0, "resIntent":Landroid/content/Intent;
    const-string v1, "flag"

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 15
    const/4 v1, -0x1

    invoke-virtual {p0, v1, v0}, Lcom/mobiotsec/nojumpstarts/C;->setResult(ILandroid/content/Intent;)V

    .line 16
    invoke-virtual {p0}, Lcom/mobiotsec/nojumpstarts/C;->finish()V

    .line 17
    return-void
.end method


# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 5
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 21
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 22
    invoke-virtual {p0}, Lcom/mobiotsec/nojumpstarts/C;->getIntent()Landroid/content/Intent;

    move-result-object v0

    .line 23
    .local v0, "data":Landroid/content/Intent;
    const-string v1, "authmsg"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 24
    .local v1, "msg":Ljava/lang/String;
    const-string v2, "sender"

    invoke-virtual {v0, v2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 25
    .local v2, "sender":Ljava/lang/String;
    const-string v3, "authsign"

    invoke-virtual {v0, v3}, Landroid/content/Intent;->getByteArrayExtra(Ljava/lang/String;)[B

    move-result-object v3

    .line 26
    .local v3, "sign":[B
    const-string v4, "com.mobiotsec.nojumpstarts"

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    if-eqz v1, :cond_1

    if-eqz v3, :cond_1

    sget-object v4, Lcom/mobiotsec/nojumpstarts/C;->expectedMsg:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-static {v1, v3}, Lcom/mobiotsec/nojumpstarts/Main;->verify(Ljava/lang/String;[B)Z

    move-result v4

    if-nez v4, :cond_0

    goto :goto_0

    .line 29
    :cond_0
    sget-object v4, Lcom/mobiotsec/nojumpstarts/MainActivity;->flag:Ljava/lang/String;

    invoke-direct {p0, v4}, Lcom/mobiotsec/nojumpstarts/C;->reply(Ljava/lang/String;)V

    goto :goto_1

    .line 27
    :cond_1
    :goto_0
    const-string v4, "C: broken auth"

    invoke-direct {p0, v4}, Lcom/mobiotsec/nojumpstarts/C;->reply(Ljava/lang/String;)V

    .line 31
    :goto_1
    return-void
.end method
