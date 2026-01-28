.class public Lcom/mobiotsec/nojumpstarts/A;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "A.java"


# static fields
.field static final synthetic $assertionsDisabled:Z

.field private static expectedMsg:Ljava/lang/String;


# instance fields
.field someActivityResultLauncher:Landroidx/activity/result/ActivityResultLauncher;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Landroidx/activity/result/ActivityResultLauncher<",
            "Landroid/content/Intent;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 21
    nop

    .line 22
    const-string v0, "Main-to-A"

    sput-object v0, Lcom/mobiotsec/nojumpstarts/A;->expectedMsg:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 21
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 25
    new-instance v0, Landroidx/activity/result/contract/ActivityResultContracts$StartActivityForResult;

    invoke-direct {v0}, Landroidx/activity/result/contract/ActivityResultContracts$StartActivityForResult;-><init>()V

    new-instance v1, Lcom/mobiotsec/nojumpstarts/A$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/mobiotsec/nojumpstarts/A$$ExternalSyntheticLambda0;-><init>(Lcom/mobiotsec/nojumpstarts/A;)V

    invoke-virtual {p0, v0, v1}, Lcom/mobiotsec/nojumpstarts/A;->registerForActivityResult(Landroidx/activity/result/contract/ActivityResultContract;Landroidx/activity/result/ActivityResultCallback;)Landroidx/activity/result/ActivityResultLauncher;

    move-result-object v0

    iput-object v0, p0, Lcom/mobiotsec/nojumpstarts/A;->someActivityResultLauncher:Landroidx/activity/result/ActivityResultLauncher;

    return-void
.end method

.method private reply(Ljava/lang/String;)V
    .locals 2
    .param p1, "flag"    # Ljava/lang/String;

    .line 36
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    .line 37
    .local v0, "resIntent":Landroid/content/Intent;
    const-string v1, "flag"

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 38
    const/4 v1, -0x1

    invoke-virtual {p0, v1, v0}, Lcom/mobiotsec/nojumpstarts/A;->setResult(ILandroid/content/Intent;)V

    .line 39
    invoke-virtual {p0}, Lcom/mobiotsec/nojumpstarts/A;->finish()V

    .line 40
    return-void
.end method


# virtual methods
.method synthetic lambda$new$0$com-mobiotsec-nojumpstarts-A(Landroidx/activity/result/ActivityResult;)V
    .locals 2
    .param p1, "result"    # Landroidx/activity/result/ActivityResult;

    .line 28
    invoke-virtual {p1}, Landroidx/activity/result/ActivityResult;->getResultCode()I

    move-result v0

    const/4 v1, -0x1

    if-ne v0, v1, :cond_1

    .line 29
    invoke-virtual {p1}, Landroidx/activity/result/ActivityResult;->getData()Landroid/content/Intent;

    move-result-object v0

    .line 30
    .local v0, "data":Landroid/content/Intent;
    if-eqz v0, :cond_0

    .line 31
    const-string v1, "flag"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0, v1}, Lcom/mobiotsec/nojumpstarts/A;->reply(Ljava/lang/String;)V

    goto :goto_0

    .line 30
    :cond_0
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    throw v1

    .line 33
    .end local v0    # "data":Landroid/content/Intent;
    :cond_1
    :goto_0
    return-void
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 5
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 44
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 45
    invoke-virtual {p0}, Lcom/mobiotsec/nojumpstarts/A;->getIntent()Landroid/content/Intent;

    move-result-object v0

    .line 46
    .local v0, "data":Landroid/content/Intent;
    const-string v1, "authmsg"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 47
    .local v1, "msg":Ljava/lang/String;
    const-string v2, "authsign"

    invoke-virtual {v0, v2}, Landroid/content/Intent;->getByteArrayExtra(Ljava/lang/String;)[B

    move-result-object v2

    .line 48
    .local v2, "sign":[B
    if-eqz v1, :cond_2

    if-eqz v2, :cond_2

    sget-object v3, Lcom/mobiotsec/nojumpstarts/A;->expectedMsg:Ljava/lang/String;

    invoke-virtual {v1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    invoke-static {v1, v2}, Lcom/mobiotsec/nojumpstarts/Main;->verify(Ljava/lang/String;[B)Z

    move-result v3

    if-nez v3, :cond_0

    goto :goto_0

    .line 52
    :cond_0
    :try_start_0
    const-string v3, "A"

    const-string v4, "B"

    invoke-static {v3, v4, v1}, Lcom/mobiotsec/nojumpstarts/Main;->buildIntent(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v3

    .line 53
    .local v3, "datas":Landroid/content/Intent;
    if-eqz v3, :cond_1

    .line 54
    iget-object v4, p0, Lcom/mobiotsec/nojumpstarts/A;->someActivityResultLauncher:Landroidx/activity/result/ActivityResultLauncher;

    invoke-virtual {v4, v3}, Landroidx/activity/result/ActivityResultLauncher;->launch(Ljava/lang/Object;)V

    .line 58
    .end local v3    # "datas":Landroid/content/Intent;
    goto :goto_1

    .line 53
    .restart local v3    # "datas":Landroid/content/Intent;
    :cond_1
    new-instance v4, Ljava/lang/AssertionError;

    invoke-direct {v4}, Ljava/lang/AssertionError;-><init>()V

    .end local v0    # "data":Landroid/content/Intent;
    .end local v1    # "msg":Ljava/lang/String;
    .end local v2    # "sign":[B
    .end local p1    # "savedInstanceState":Landroid/os/Bundle;
    throw v4
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 56
    .end local v3    # "datas":Landroid/content/Intent;
    .restart local v0    # "data":Landroid/content/Intent;
    .restart local v1    # "msg":Ljava/lang/String;
    .restart local v2    # "sign":[B
    .restart local p1    # "savedInstanceState":Landroid/os/Bundle;
    :catch_0
    move-exception v3

    .line 57
    .local v3, "e":Ljava/lang/Exception;
    invoke-virtual {v3}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1

    .line 49
    .end local v3    # "e":Ljava/lang/Exception;
    :cond_2
    :goto_0
    const-string v3, "A: broken auth"

    invoke-direct {p0, v3}, Lcom/mobiotsec/nojumpstarts/A;->reply(Ljava/lang/String;)V

    .line 60
    :goto_1
    return-void
.end method
