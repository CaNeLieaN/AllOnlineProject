*** Settings ***
Documentation     Test Suite สำหรับทดสอบการสั่งซื้อสินค้าผ่านเว็บ AllOnline
...               โดยเลือกรับสินค้าที่ร้านและชำระเงินด้วย QR Payment
Library    SeleniumLibrary
Test Teardown    Close Browser

*** Variables ***
${TIMEOUT}    5s
${URL}    https://www.allonline.7eleven.co.th/
${PRODUCT_NAME}    COMPRO ตู้เย็นมินิ ความจุ 4 ลิตร รุ่น CP-MINI2 - ขาว
${USERNAME}    caneliean@gmail.com
${PASSWORD}    M@makub123
${CUSTOMER_NAME}    ศุภชัย สกุลปั่น
${PHONE}    0959595548
${STORE_ID}    00262
${STORE_NAME}    สี่แยกบ้านแขก
${STORE_ADDRESS}    เลขที่  ถ.ประชาธิปก, 395-397, แขวงสมเด็จเจ้าพระยา เขตคลองสาน กรุงเทพฯ 10600
${Quantity}    1
${EXPECTED_PRICE}    844
${EXPECTED_POINTS}    252

*** Test Cases ***
ลูกค้าสั่งซื้อสินค้าสำเร็จ
    [Documentation]    ทดสอบการสั่งซื้อสินค้าโดยเลือกรับที่ร้านและชำระด้วย QR Payment
    เปิดหน้าเว็บ
    ล๊อคอินเข้าสู่ระบบ
    ค้นหาสินค้า
    เลือกสินค้าและยืนยันการซื้อ    
    ไปที่หน้ากรอกข้อมูลการจัดส่ง
    เลือกสาขารับสินค้า
    เลือกวิธีชำระเงิน
    ตรวจสอบรายละเอียดการสั่งซื้อกดชำระเงิน
    # ยืนยันการสั่งซื้อ
    # ตรวจสอบการสั่งซื้อสำเร็จ

*** Keywords ***
เปิดหน้าเว็บ
    Open Browser    url=${URL}    browser=chrome
    Maximize Browser Window    

ล๊อคอินเข้าสู่ระบบ
    Click Element    xpath=//*[@id="page"]/header/div[4]/div/div/div/ul/li[4]/a    
    Input Text    name=email    ${USERNAME}
    Input Password    name=password    ${PASSWORD}
    Click Element    xpath=//*[@id="__next"]/div/div/div[2]/div[2]/div/div/div/div[6]/a[1]

ค้นหาสินค้า
    Wait Until Page Contains Element    name=q    timeout=${TIMEOUT}
    Input Text    name=q    ${PRODUCT_NAME}
    Press Keys    name=q    ENTER
    Wait Until Page Contains Element    css=.product-list    timeout=${TIMEOUT}

เลือกสินค้าและยืนยันการซื้อ
    Wait Until Element Is Visible    xpath=//*[@id="page"]/div[2]/div[2]/div/div/div[2]/div/div/div/div/div/div[3]/div[1]/div/a[1]    timeout=${TIMEOUT}
    Click Element    id=btn-accept-gdpr
    Double Click Element    xpath=//*[@id="page"]/div[2]/div[2]/div/div/div[2]/div/div/div/div/div/div[3]/div[1]/div/a[1]/div/div[3]
    Wait Until Element Is Visible    xpath=//*[@id="article-form"]/div[2]/div[2]/div[4]/div[2]/button    timeout=${TIMEOUT}
    Click Element    xpath=//*[@id="article-form"]/div[2]/div[2]/div[4]/div[2]/button

ไปที่หน้ากรอกข้อมูลการจัดส่ง
    Wait Until Element Is Visible    xpath=//*[@id="address-tabs"]/ul/li[1]/a    timeout=${TIMEOUT}
    Click Element    xpath=//*[@id="address-tabs"]/ul/li[1]/a    

เลือกสาขารับสินค้า    
    Input Text    id=second-phone-shipping    ${PHONE}
    Click Element    xpath=//*[@id="storefinder-selector-group"]/div[1]/div/button
    Wait Until Element Is Visible    xpath=//*[@id="user-storenumber-input"]    timeout=${TIMEOUT}
    Input Text    id=user-storenumber-input    00262
    Click Element    xpath=//*[@id="btn-check-storenumber"]
    Wait Until Element Is Visible    class=storefinder-address    timeout=${TIMEOUT}
    Click Element    id=continue-payment-btn

เลือกวิธีชำระเงิน
    Click Element    xpath=//*[@id="payment-options"]/div[4]    

ตรวจสอบรายละเอียดการสั่งซื้อกดชำระเงิน   
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/div    ${CUSTOMER_NAME}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[1]/td    ${PHONE}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[1]/td/div[2]/span    ${STORE_NAME}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[1]/td/div[2]/span    ${STORE_ADDRESS}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[3]/td[3]    ${Quantity}
    Element Should Contain    xpath=//*[@id="stepModel"]/div[1]/div[2]/div[2]/table/tbody[1]/tr[3]/td[4]    ${EXPECTED_PRICE}
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[2]/td[2]/b    ฟรี
    Element Should Contain    xpath=//*[@id="js-invoice-details-tbody"]/tr[17]/td[2]    ${EXPECTED_POINTS}
    Click Element    xpath=//*[@id="stepModel"]/div[1]/div[2]/footer/div/div/button
