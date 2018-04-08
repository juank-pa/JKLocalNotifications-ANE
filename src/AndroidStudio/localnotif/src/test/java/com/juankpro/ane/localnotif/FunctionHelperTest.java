package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.juankpro.ane.localnotif.fre.FunctionHelper;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static junit.framework.Assert.assertSame;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.powermock.api.mockito.PowerMockito.verifyStatic;

/**
 * Created by juank on 11/26/2017.
 */

@RunWith(PowerMockRunner.class)
@PrepareForTest({FREObject.class})
public class FunctionHelperTest {
    @Mock
    private FREObject freObject;
    @Mock
    private FREObject freResultObject;
    @Mock
    private FREContext freContext;
    private FREObject[] freArgs;
    private FunctionHelper subject;
    private boolean called;

    private FunctionHelper getSubject(final String error) {
        if (subject == null) {
            called = true;
            subject = new FunctionHelper() {
                @Override
                public FREObject invoke(FREContext context, FREObject[] passedArgs) throws Throwable {
                    if(error != null) {
                        Exception exception = mock(Exception.class);
                        when(exception.toString()).thenReturn("java.lang.Exception: My Error");

                        throw exception;
                    }
                    return context == FunctionHelperTest.this.freContext &&
                            passedArgs == freArgs? freObject : null;
                }
            };
        }
        return subject;
    }

    private FunctionHelper getSubject() {
        return getSubject(null);
    }

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        PowerMockito.mockStatic(FREObject.class);
        freArgs = new FREObject[]{};
    }

    @Test
    public void helper_call_callsInvoke() throws Throwable {
        assertSame(freObject, getSubject().call(freContext, freArgs));
    }

    @Test
    public void helper_call_forwardsErrorToANEIfErrorThrown() throws FREWrongThreadException {
        try {
            when(FREObject.newObject(anyString())).thenReturn(freResultObject);
        } catch (Throwable e) { e.printStackTrace(); }

        assertSame(freResultObject, getSubject("My Error").call(freContext, freArgs));

        verifyStatic(FREObject.class);
        FREObject.newObject("Exception! java.lang.Exception: My Error");
    }
}
