.class public Lcom/mobiotsec/nojumpstarts/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"


# static fields
.field static final synthetic $assertionsDisabled:Z = false

.field private static final TAG:Ljava/lang/String; = "MOBIOTSEC"

.field public static flag:Ljava/lang/String;


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

    .line 23
    nop

    .line 25
    const-string v0, "dummy-flag"

    sput-object v0, Lcom/mobiotsec/nojumpstarts/MainActivity;->flag:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 23
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 29
    new-instance v0, Landroidx/activity/result/contract/ActivityResultContracts$StartActivityForResult;

    invoke-direct {v0}, Landroidx/activity/result/contract/ActivityResultContracts$StartActivityForResult;-><init>()V

    new-instance v1, Lcom/mobiotsec/nojumpstarts/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lcom/mobiotsec/nojumpstarts/MainActivity$$ExternalSyntheticLambda0;-><init>(Lcom/mobiotsec/nojumpstarts/MainActivity;)V

    invoke-virtual {p0, v0, v1}, Lcom/mobiotsec/nojumpstarts/MainActivity;->registerForActivityResult(Landroidx/activity/result/contract/ActivityResultContract;Landroidx/activity/result/ActivityResultCallback;)Landroidx/activity/result/ActivityResultLauncher;

    move-result-object v0

    iput-object v0, p0, Lcom/mobiotsec/nojumpstarts/MainActivity;->someActivityResultLauncher:Landroidx/activity/result/ActivityResultLauncher;

    return-void
.end method

.method private setFlag(Landroid/content/Intent;)V
    .locals 3
    .param p1, "intent"    # Landroid/content/Intent;

    .line 49
    if-eqz p1, :cond_0

    const-string v0, "flag"

    invoke-virtual {p1, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object v1, v0

    .local v1, "flag2":Ljava/lang/String;
    if-eqz v0, :cond_0

    .line 50
    sput-object v1, Lcom/mobiotsec/nojumpstarts/MainActivity;->flag:Ljava/lang/String;

    .line 51
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "flag set correctly: "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v2, Lcom/mobiotsec/nojumpstarts/MainActivity;->flag:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "MOBIOTSEC"

    invoke-static {v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 53
    .end local v1    # "flag2":Ljava/lang/String;
    :cond_0
    return-void
.end method


# virtual methods
.method public getFlag()V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 56
    const-string v0, "A"

    const/4 v1, 0x0

    const-string v2, "Main"

    invoke-static {v2, v0, v1}, Lcom/mobiotsec/nojumpstarts/Main;->buildIntent(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v0

    .line 57
    .local v0, "datas":Landroid/content/Intent;
    if-eqz v0, :cond_0

    .line 58
    iget-object v1, p0, Lcom/mobiotsec/nojumpstarts/MainActivity;->someActivityResultLauncher:Landroidx/activity/result/ActivityResultLauncher;

    invoke-virtual {v1, v0}, Landroidx/activity/result/ActivityResultLauncher;->launch(Ljava/lang/Object;)V

    .line 59
    return-void

    .line 57
    :cond_0
    new-instance v1, Ljava/lang/AssertionError;

    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    throw v1
.end method

.method synthetic lambda$new$0$com-mobiotsec-nojumpstarts-MainActivity(Landroidx/activity/result/ActivityResult;)V
    .locals 4
    .param p1, "result"    # Landroidx/activity/result/ActivityResult;

    .line 32
    invoke-virtual {p1}, Landroidx/activity/result/ActivityResult;->getResultCode()I

    move-result v0

    const/4 v1, -0x1

    if-ne v0, v1, :cond_1

    .line 33
    invoke-virtual {p1}, Landroidx/activity/result/ActivityResult;->getData()Landroid/content/Intent;

    move-result-object v0

    .line 34
    .local v0, "data":Landroid/content/Intent;
    if-eqz v0, :cond_1

    .line 35
    sget v1, Lcom/mobiotsec/nojumpstarts/R$id;->flag:I

    invoke-virtual {p0, v1}, Lcom/mobiotsec/nojumpstarts/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    .line 36
    .local v1, "flagWidget":Landroid/widget/TextView;
    const-string v2, "flag"

    invoke-virtual {v0, v2}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 37
    .local v2, "flag2":Ljava/lang/String;
    const-string v3, "MOBIOTSEC"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 38
    if-eqz v2, :cond_0

    .line 39
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0

    .line 41
    :cond_0
    const-string v3, "flag was null"

    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 45
    .end local v0    # "data":Landroid/content/Intent;
    .end local v1    # "flagWidget":Landroid/widget/TextView;
    .end local v2    # "flag2":Ljava/lang/String;
    :cond_1
    :goto_0
    return-void
.end method

.method synthetic lambda$onCreate$1$com-mobiotsec-nojumpstarts-MainActivity(Landroid/widget/TextView;Landroid/view/View;)V
    .locals 4
    .param p1, "flagWidget"    # Landroid/widget/TextView;
    .param p2, "v"    # Landroid/view/View;

    .line 69
    const-string v0, "Getting flag...."

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 70
    const-string v0, "Getting flag..."

    const-string v1, "MOBIOTSEC"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 71
    const/high16 v0, -0x10000

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 73
    :try_start_0
    invoke-virtual {p0}, Lcom/mobiotsec/nojumpstarts/MainActivity;->getFlag()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 77
    goto :goto_0

    .line 74
    :catch_0
    move-exception v0

    .line 75
    .local v0, "e":Ljava/lang/Exception;
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Exception while getting the flag:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v0}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    const-string v1, "An error occurred when getting flag"

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 78
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 63
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 64
    sget v0, Lcom/mobiotsec/nojumpstarts/R$layout;->activity_main:I

    invoke-virtual {p0, v0}, Lcom/mobiotsec/nojumpstarts/MainActivity;->setContentView(I)V

    .line 65
    invoke-virtual {p0}, Lcom/mobiotsec/nojumpstarts/MainActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/mobiotsec/nojumpstarts/MainActivity;->setFlag(Landroid/content/Intent;)V

    .line 66
    sget v0, Lcom/mobiotsec/nojumpstarts/R$id;->flag:I

    invoke-virtual {p0, v0}, Lcom/mobiotsec/nojumpstarts/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    .line 67
    .local v0, "flagWidget":Landroid/widget/TextView;
    const-string v1, "MOBIOTSEC"

    const-string v2, "onStart"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 68
    sget v1, Lcom/mobiotsec/nojumpstarts/R$id;->getflag:I

    invoke-virtual {p0, v1}, Lcom/mobiotsec/nojumpstarts/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Button;

    new-instance v2, Lcom/mobiotsec/nojumpstarts/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v2, p0, v0}, Lcom/mobiotsec/nojumpstarts/MainActivity$$ExternalSyntheticLambda1;-><init>(Lcom/mobiotsec/nojumpstarts/MainActivity;Landroid/widget/TextView;)V

    invoke-virtual {v1, v2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 79
    return-void
.end method
